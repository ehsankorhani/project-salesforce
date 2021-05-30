# Security in Salesforce

## Data Security

Are different security layers that we can configure in an Org to prevent access to data.

There are 3 layers of data security:

1. Object level security: ability to access specific **object** in the Org (CRUD).
2. FLS: Field Level Security which controls the ability to view **fields** in an object.
3. Sharing: ability to view **records** in an Org. 

There are many ways to configure these security settings. 

### User mode vs System mode

In Salesforce we have two execution modes.

CRUD, FLS, and Sharing enforced in User mode by default. User mode consist of:

- Standard UIs
- API Calls (REST, SOAP, UI API, ...)
- Execute Anonymous
- Standard Controllers

In System mode, CRUD, FLS, and Sharing are NOT enforced by default. That is the case for everything with regards to Apex.

Apex classes, Triggers, and Apex Web Services run in System mode.

Here we review how to enforce these securities in code.

## Enforce Object and Field level security

There are objects and tables that can be queried in order to find out about accesses. But there are more convenient ways to check if user has permissions to query or update or create a record.

|   | Read data (SOQL) | Modify data (DML) |
| ---------------------- |:-------------:| -----:|
| Schema methods         | * | * |
| WITH SECURITY_ENFORCED | * | - |
| Security.stripInacsessible() | * | * |
| Database operations in user mode (pilot) | * | * |

<br>

### No Security

The code below will return all records on the Account object even if the user has no READ permission on the object:

```java
public with sharing class AccountController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Name, AnnualRevenue, Industry FROM Account ORDER BY Name];
    }

}
```

Note that `with sharing` is only enforces Sharing Rules on the records.

<br>

### Schema methods

Oldest method of checking CRUD and FLS.

By using `isAccessible()` schema method the user will not be able to view the object if no Read access is available:

```java
@AuraEnabled(cacheable=true)
public static List<Account> getAccountsCRUDCheck() {
    if (Schema.sObjectType.Account.isAccessible()) {
        return [SELECT Name, AnnualRevenue, Industry FROM Account ORDER BY Name];
    }

    return new List<Account>();
}
```

To enforce Field Level Security we can write the above as:

```java
@AuraEnabled(cacheable=true)
public static List<Account> getAccountsFLSCheck() {
    if (
        Schema.sObjectType.Account.fields.Name.isAccessible() &&
        Schema.sObjectType.Account.fields.AnnualRevenue.isAccessible() &&
        Schema.sObjectType.Account.fields.Industry.isAccessible()
    ) {
        return [SELECT Name, AnnualRevenue, Industry FROM Account ORDER BY Name];
    }

    return new List<Account>();
}
```

If any of the fields are not accessible - by user - no records will be returned.

In this method of Field Level Security the Object level access will be implicit.

<br>

### `WITH SECURITY_ENFORCED`

Is a clause that is used in SOQL queries and will result in the query returning records only if the Object is readable and all fields are accessible.

```java
@AuraEnabled(cacheable=true)
public static List<Account> getAccountsWithSecurityEnforced() {
    return [
        SELECT Name, AnnualRevenue, Industry
        FROM Account
        WITH SECURITY_ENFORCED
        ORDER BY Name
    ];
}
```

<br>

### Security.stripInacsessible()

Is used in Apex code to help with database queries and DML operations.

The `stripInacsessible()` will return only the fields that we have read access to - if the Object has the defined `AccessType` as well. It will not display data for the fields (columns) that the user does not have a read permission on them.

```java
@AuraEnabled(cacheable=true)
public static List<Account> getAccountsStripInaccessible() {
    SObjectAccessDecision securityDecision = Security.stripInaccessible(
      AccessType.READABLE,
      [SELECT Name, AnnualRevenue, Industry FROM Account ORDER BY Name]
    );

    return securityDecision.getRecords();
}
```

<br>

### User mode Database operations (pilot)

Using `Schema` methods are hard and verbose. The `WITH SECURITY_ENFORCED` is also only only available for queries.

The *User Mode* will help in CRUD, FLS and Sharing. It provides new parameter on:

- Database.query methods
- Search.query methods
- Database DML methods (insert, update, upsert, merge, delete, undelete)

Without check for any security feature the user can create an Account even without a Create permission:

```java
@AuraEnabled
public static Account createAccount() {
    Account acct = new Account();
    acct.Name = 'Cruzcampo';
    acct.AnnualRevenue = 1000000;
    acct.Industry = 'Food & Beverage';

    insert acct;

    return acct;
}
```

<br>

However, checking permission with a `Schema` method can prevent this:

```java
@AuraEnabled
public static Account createAccountCRUDCheck() {
    Account acct;
    if (Schema.sObjectType.Account.isCreateable()) {
      acct = new Account();
      acct.Name = 'Cruzcampo';
      acct.AnnualRevenue = 1000000;
      acct.Industry = 'Food & Beverage';

      insert acct;
    } else {
      throw new DMLException('No object permissions to create account.');
    }

    return acct;
}
```

<br>

The same happens with FLS checking. It is more accurate way because we can check for both Object create permission and permissions on every single field:

```java
@AuraEnabled
public static Account createAccountFLSCheck() {
    Account acct;
    if (
      Schema.sObjectType.Account.fields.Name.isCreateable() &&
      Schema.sObjectType.Account.fields.AnnualRevenue.isCreateable() &&
      Schema.sObjectType.Account.fields.Industry.isCreateable()
    ) {
      acct = new Account();
      acct.Name = 'Cruzcampo';
      acct.AnnualRevenue = 1000000;
      acct.Industry = 'Food & Beverage';

      insert acct;
    } else {
      throw new DMLException('No field permissions to create account.');
    }

    return acct;
}
```

<br>

The `stripInaccessible()` method can be used to strip Object from fields that the user has no *Edit* access to and then insert the resulting object.

```java
@AuraEnabled
public static Account createAccountStripInaccessible() {
    Account acct = new Account();
    acct.Name = 'Cruzcampo';
    acct.AnnualRevenue = 1000000;
    acct.Industry = 'Food & Beverage';

    SObjectAccessDecision securityDecision = Security.stripInaccessible(
        AccessType.CREATABLE,
        new List<Account>{ acct }
    );

    insert securityDecision.getRecords();

    return (Account) securityDecision.getRecords()[0];
  }
}
```

Note that the User requires to have *Create* permission on the whole object.

<br>

### CanTheUser

Another cool library is the `CanTheUser` class on `apex-recipes` repo in GitHub.

With this library we can check if User has access to a record in the following way:

```java
if(CanTheUser.read(new account())){
    // ...
}
```

<br>
<br>

## Record-level Security (Sharing)

When `with sharing` keyword applied to an Apex class declaration, the runtime filters out records returned by SOQL queries that do not meet the sharing rules for the current user context.

If it is not specified, then this is inherited from the outermost Apex class that controls the execution.
The `without sharing` keyword can be used to explicitly enable the return of all records meeting the query.

|                        | Sharing Enforced |
| ---------------------- |:----------------:|
| with sharing           | * |
| without sharing        | - |
| inherited sharing      | inherited from parent. `with sharing` if entry point |
| no sharing clause      | inherited from parent. `without sharing` if entry point except for lightning |

<br>

```java
public inherited sharing class AccountControllerInheritedSharing {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Name, AnnualRevenue, Industry FROM Account ORDER BY Name];
    }
}
```

### `System.runAs()`

Enforces sharing (not CRUD or FLS) only for the Test mode.

```java
User u = new User(UserName='uniqueUser', Alias='standt', email='standarduser@testorg.com');


System.runAs(u) {
    // code will run as user u
    // ...
}
```

<br>

---

<br>
<br>

## Data Security in LWC

LWC Base Components enforce CRUD, FLS, and Sharing

- `lightning-record-form`
- `lightning-record-edit-form`
- `lightning-record-view-form`

LDS `Wire` adapters and functions enforce CRUD, FLS, and Sharing

When calling Apex the Apex level security applies.

<br>
<br>

## Application Security

### SOQL Injection

```java
@AuraEnabled(cacheable=true)
public static List<Account> getFilteredAccountsInjection(String searchValue) {
    return (List<Account>) Database.query(
        'SELECT Name, AnnualRevenue, Industry FROM Account WHERE Name LIKE \'%' +
        searchValue +
        '%\' ORDER BY Name'
    );
}
```

- Use static queries
- If needed to use dynamic queries, always bind user input with ":"
- If not possible, escape, typecast or whitelist inputs

```java
@AuraEnabled(cacheable=true)
public static List<Account> getFilteredAccounts(String searchValue) {
    return (List<Account>) Database.query(
        'SELECT Name, AnnualRevenue, Industry FROM Account WHERE Name LIKE \'%' +
        String.escapeSingleQuotes(searchValue) +
        '%\' ORDER BY Name'
    );
}
```

<br>

### Locker Service

- JavaScript Strict mode enforcement
- DOM Access containment
  - Safe Harbour: mechanism to relax this restriction

**Locker Console** can be used to try and evaluate an script - without needing to create the component.

<br>

### Preventing XSS

Stay away from DOM manipulation `(lwc:dom="manual")` and use template directives => Sanitization of inputs! 

Avoid:

- Eval
- DOMParser.parseFromString
- Document.implementation.createHTMLDocument
- setTimeout
- setInterval

+ Apply input filtering (i.e. don't allow `>`)
+ Apply output encoding (i.e. `>` to `&ls;`)

<br>

### Preventing CSRF

- Don't change state (execute DML) on component load - connectedCallback, renderedCallback, ...
- Validate `origin` header on your exposed API endpoints or add custom token for CSRF protection.

<br>

---

<br>
<br>

## Sensitive Data Exposure

### What are Secrets?

- Passwords
- Encryption keys
- OAuth tokens
- Payment information
- Social security numbers

<br>

### Storing Secrets

- Named credentials
- Protected custom settings
- Protected custom metadata / custom metadata records
- Encrypt secrets in code

<br>

#### 1. Named credentials

Use `Named credential` along with `Auth. Provider` to make a secure callout code.

It can use **Merge Fields** to send data specified in Auth. Provider.

For example:

```java
req.setHeader('X-Username', '{!$Credential.UserName}');
```

For a complete documentation see: [Merge Fields for Apex Callouts That Use Named Credentials](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_named_credentials_merge_fields.htm).

**Note:**

By checking the `Generate Authorization Header` in Named Credential, Salesforce generates an authorization header and applies it to each callout that references the named credential.

However, if you check the `Allow Merge Fields in HTTP` in `Header` or `Body`, the code specifies how the HTTP header and request body are constructed.

<br>

#### 2. Protected Custom Settings

There are two types of Custom Settings in a Managed Package:

1. **Public**
2. **Protected**: good place to store sensitive information

The `Protected` Custom Setting is only accessible by the Namespace or the Package that they are defined in. The Target/Subscriber org will not be able to see the settings.

To be able to read data from protected custom settings the We can create a `global` service:

```java
global class AuthenticatedService {

    global static String useProtectedCustomSettings() {
        Protected_Setting__c setting = Protected_Setting__c.getInstance();
        return setting.Sensitive_Field__c;
    }

    // ...
}
```

Note that we can access `global` class and methods from the subscriber org.

<br>

#### 3. Protected Custom Metadata

Similar to Custom Settings we can create `protected` Custom Metadata to store sensitive data and access it via a global service:

```java
global class AuthenticatedService {

    global static String useProtectedCustomMetadata() {
        Protected_Metadata__mdt[] mds = [SELECT Sensitive_Field__c FROM Protected_Metadata__mdt WHERE DeveloperName = 'Public_Record'];
        return mds[0].Sensitive_Field__c;
    }

    // ...
}
```

<br>

#### 4. Protected Custom Metadata Record

Public Custom Metadata can contain `protected` records. TO access them in a subscriber org we can write this service:

```java
global class AuthenticatedService {

    global static String useProtectedCustomMetadataRecord() {
        Protected_Metadata__mdt[] mds = [SELECT Sensitive_Field__c FROM Protected_Metadata__mdt WHERE DeveloperName = 'Protected_Record'];
        return mds[0].Sensitive_Field__c;
    }

    // ...
}
```

<br>

#### Store sensitive information

In case we needed to store data we can only use the *Protected Custom Settings*:

```java
global class AuthenticatedService {

    global static void populateCustomSetting() {
        insert new Protected_Setting__c(SetupOwnerId=UserInfo.getOrganizationId(), Sensitive_Field__c ='myPwd!');        
    }

    // ...
}
```

<br>

#### 5. Encrypt secrets in code

In order to encrypt data we need to use the `crypto` class.

To encrypt a string using the crypto class:

```java
public with sharing class Encryption {

  @AuraEnabled
  public static String encryptAES256() {
    // Generate AES key (private key)
    Blob cryptoKey = Crypto.generateAesKey(256);

    Blob data = Blob.valueOf('Test data');

    Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);

    // Encode Blob in Base64
    return EncodingUtil.base64Encode(encryptedData);
  }

  // ...
}
```

The external system can use the `key` and the specified algorithm to decrypt data.

The `AES256` does not enforce data integrity, for that we can use other algorithms such as `Hash Digest`.

To make sure that data was not corrupted, these algorithm generate a digest:

```java
public with sharing class Encryption {

  @AuraEnabled
  public static String hashSHA512() {
    Blob data = Blob.valueOf('Test data');

    Blob hash = Crypto.generateDigest('SHA512', data);

    // Encode Blob in Base64
    return EncodingUtil.base64Encode(hash);
  }

  // ...
}
```

The destination can generate the digest again to ensure that the data is same as the one in source.

To make this more secure we can use `mac` (Message Authentication Code) and use a private key as well:

```java
public with sharing class Encryption {

  @AuraEnabled
  public static String macHMAC512() {
    // Use private key
    Blob cryptoKey = Blob.valueOf('mysupersecretkey');

    Blob data = Blob.valueOf('Test data');

    Blob mac = Crypto.generateMac('hmacSHA512', data, cryptoKey);

    // Encode Blob in Base64
    return EncodingUtil.base64Encode(mac);
  }

  // ...
}
```

The destination is going to need the private key to decrypt the code.

Finally, we can use a `Digital Signature` so the target code would not need to know the private key, but only a **public key**.

```java
public with sharing class Encryption {

  static final String PRIVATE_KEY = 'XXXX';

  @AuraEnabled
  public static String digitalSignature() {
    // Use private key (must be in RSA's PKCS #8 (1.2) Private-Key Information Syntax Standard form)
    Blob cryptoKey = EncodingUtil.base64Decode(PRIVATE_KEY);

    Blob data = Blob.valueOf('Test data');

    Blob digitalSignature = Crypto.sign('RSA', data, cryptoKey);

    // Encode Blob in Base64
    return EncodingUtil.base64Encode(digitalSignature);
  }

}
```

<br>
<br>

---

<br>

### References

- [Alba Rivas - Salesforce Apex Hours - Security in Salesforce](https://youtu.be/RMTA06yWNms)
- [Code Examples that show how to enforce security in Apex and LWC](https://github.com/albarivas/security)
- Andrew Fawcett - Salesforce Lightning Platform Enterprise Architecture
- [Alba Rivas - Security for Salesforce Developers: Storing Secrets (Episode III)](https://youtu.be/aqztf1nJv-k)
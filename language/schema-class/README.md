# Schema class

Schema class is used to make a dynamic application. Schema is a Namespace which contains methods for obtaining schema describe information.

With Schema class you can:
- Query any object and it's fields. it enables us to interact with the database without any utilizing SOQL queries.
- Access sObject and field describe information.
- Access Salesforce app information.

## The Namespace

The `Schema.*` is imported implicitly and it can be omitted (except when there is naming conflict).

Therefore, these code segments are equivalent:
```java
Schema.DescribeSObjectResult d = Account.sObjectType.getDescribe();
```
And:
```java
DescribeSObjectResult d = Account.sObjectType.getDescribe();
```

The `schema` namespace can be used to refer to sObjects as well:

```java
Schema.Account myAccountSObject = new Schema.Account();
```
<br>

## Apex Describe Information

Three ways to get describe information:
1. **Token** - serializable reference to an sObject or a field
   ```java
   Schema.sObjectType t = Account.sObjectType;
   // Or
   Schema.sObjectType t = new Account().getSObjectType();
   ```
   Validates at compile time.<br><br>
2. `describeSObjects` method - allows you to specify the sObject type dynamically and describe more than one sObject at a time
   ```java
   Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{'Account','Contact'});
   ```
   <br><br>
3. Describe result - object of type `Schema.DescribeSObjectResult`
   ```java
   Schema.DescribeSObjectResult dsr = Account.sObjectType.getDescribe();
   ```
   Validates at runtime and are are not serializable.

<br>

### Describing sObjects Using Tokens

- Tokens are lightweight - faster and more efficient code.
- Can be compared using the equality operator (`==`)

```java
Schema.DescribeSObjectResult dsr = Account.sObjectType.getDescribe();
Schema.DescribeFieldResult dfr = Schema.sObjectType.Account.fields.Name;
dfr = dfr.getSObjectField().getDescribe();
```

A sample algorithm to work with Describe would be:

1. Accessing All sObjects:
    ```java
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

    // {acceptedeventrelation=AcceptedEventRelation, account=Account, accountchangeevent=AccountChangeEvent, accountcleaninfo=AccountCleanInfo, accountcontactrole=AccountContactRole, ...}
    ```

2. Determine the sObject you need to access:
    ```java
    Schema.sObjectType t = gd.get('contact');

    // Contact
    ```

3. Generate the describe result for the sObject:
    ```java
    Schema.DescribeSObjectResult dsr = t.getDescribe();

    // Schema.DescribeSObjectResult[getAssociateEntityType=null;getAssociateParentEntity=null;getDataTranslationEnabled=null;getDefaultImplementation=null;getFields=Fields[Contact];getHasSubtypes=false;getImplementedBy=null;getImplementsInterfaces=null;getIsInterface=false;getIsSubtype=false;getKeyPrefix=003;getLabel=Contact;getLabelPlural=Contacts;getName=Contact;getRecordTypeInfosByDeveloperName={Master=Schema.RecordTypeInfo[getDeveloperName=Master;getName=Master;getRecordTypeId=012000000000000
    ```

4. Generate a map of field tokens for the sObject:
    ```java
    Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();

    // {accountid=AccountId, assistantname=AssistantName, assistantphone=AssistantPhone, birthdate=Birthdate, cleanstatus=CleanStatus, createdbyid=CreatedById, createddate=CreatedDate, department=Department, description=Description, email=Email, ...}
    ```

5. Generate the describe result for the field:
    ```java
    Schema.DescribeFieldResult dfr = fieldMap.get('email').getDescribe();

    // Schema.DescribeFieldResult[getByteLength=240;getCalculatedFormula=null;getCompoundFieldName=null;getController=null;getDataTranslationEnabled=null;getDefaultValue=null;getDefaultValueFormula=null;getDigits=0;getFilteredLookupInfo=null;getInlineHelpText=null;getLabel=Email;getLength=80;getLocalName=Email;getMask=null;getMaskType=null;getName=Email;getPrecision=0;getReferenceTargetField=null;getRelationshipName=null;getRelationshipOrder=null;getScale=0;getSoapType=STRING;getSobjectField=Ema
    ```
<br>

### Get Child Relationship

We can access the child relationship as well as the child sObject for a parent sObject:

```java
Schema.DescribeSobjectResult dsr = Account.sObjectType.getDescribe();

Schema.ChildRelationship[] rels = dsr.getChildRelationships();
```

<br>

### Describe Information Permissions

- Apex classes and triggers run in system mode.
- No restrictions on dynamically looking up any sObject that is available in the org.
- Anonymous code runs in User context.

<br>

### Enforce user object level and field level permissions
- Apex does not enforce object-level or field-level permission.
- Users permissions are not taken into consideration because Apex generally runs in system context.
- Apex code always has access to each field and object in an organization (to ensures that the code doesn't fail).
- The `with sharing` keyword does not enforce the users permissions or field level security.
  - With `with sharing` Apex runs in User Context and `sharing rules` enforced.
  - With `without sharing` Apex runs in System Context.

```java
Schema.sObjectType.Account.fields.Name.isUpdateable();
Schema.sObjectType.Account.fields.Name.isCreateable();
Schema.sObjectType.Account.fields.Name.isAccessible();
Schema.sObjectType.Account.isCreateable();
Schema.sObjectType.Account.isDeletable();
```

<br>

### Describing Tabs

It is possible to get metadata information about the `apps` and their `tabs` available in the Salesforce.

```java
List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();

for(DescribeTabSetResult tsr : tabSetDesc) {
    System.debug('Label: ' + tsr.getLabel(););
    System.debug('Logo URL: ' + tsr.getLogoUrl());
    System.debug('isSelected: ' + tsr.isSelected());

    List<Schema.DescribeTabResult> tabDesc = tsr.getTabs();
    //...
}
```

<br>

### Data Categories

To work with category groups associated with the specified objects we can use:

- `describeDataCategoryGroups` to return all the category groups associated with the objects of your choice.
- `describeDataCategoryGroupStructures` to retrieve the categories available to this objects.

<br><br>
---

### References
- [Schema Class - Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_schema.htm)
- Apex Developer Guide - Version 49.0, Summer ’20
- [Schema Class in Salesforce Apex | The Developer Guide](https://www.forcetalks.com/blog/schema-class-in-salesforce-apex-the-developer-guide/)
- [Schema Class in Salesforce - Level Up Salesforce](https://www.levelupsalesforce.com/schema-class-in-salesforce)
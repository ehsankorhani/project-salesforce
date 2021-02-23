# Working with sObjects

`sObject` refers to any object that can be stored in the Lightning platform database.

<br>

## sObject Types

An sObject variable represents a row of data and can only be declared in Apex using the SOAP API name of the object.

```java
Account acct = new Account();
Customer__c cust = new Customer__c();
```

We can also use generic `sObject` abstract type to represent any object:

```java
sObject s = new Account();
```

This variable can be cast to a specific object:

```java
Account a = (Account)s;
Contact c = (Contact)s; // runtime error
Object obj = s;
```

Developers can specify initial field values when instantiating a new sObject:

```java
Account a = new Account(name = 'Acme', billingcity = 'San Francisco');
```

<br>

## Accessing SObject Fields

Fields can be accessed or changed with dot notation:

```java
a.Name = 'Acme';
```

> System-generated fields, such as `Created By` or `Last Modified Date`, cannot be modified.

<br>

### Determine sObject type

The `getSObjectType()` can display the type:

```java
//...
SObject record = records[i];
if (record.getSObjectType() == Contact.sObjectType) {
    //...
}
```

<br>

## Using SObject Fields

SObject fields can be initially set or not set (unset). You can’t change unset fields.

The `System.isSet(field)` method can be used to identify the set fields.
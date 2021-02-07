# Unit Of Work Pattern

Unit of Work manages all DML transactions and their rollbacks.

It is a “utility” class focused on:
- Optimizing DML interactions with the Database layer
- Providing transactional control for the Service Layer
- Simplifying the complex code usually constructed to manage bulkified DML operations
- Managing the “plumbing” needed to save parent-child data relationships

<br>

### Usage
- Used within a service method but passed to domain methods as needed.
- Using an instance of UOW, you can register new records, modified/dirty records, and register records that need to be deleted.
- Once all records and changes are collected, the `commitWork()` method is called to begin DML transactions.

<br>

**Example**:

First, we need to have setup a SObject dependency list (typically as `UnitOfWorkFactory` in `Application.cls` class):

```java
private static List MY_SOBJECTS = new Schema.SObjectType[] {
        Product2.SObjectType,
        PricebookEntry.SObjectType,
        Opportunity.SObjectType,
        OpportunityLineItem.SObjectType };
````

Then, we can

```java
SObjectUnitOfWork uow = new SObjectUnitOfWork(MY_SOBJECTS);

for(Integer o = 0; o < 10; o++)
{
  Opportunity opp = new Opportunity();
  opp.Name = 'UoW Test Name ' + o;

  uow.registerNew(opp);

  for(Integer i = 0; i < o + 1; i++) {
    OpportunityLineItem oppLineItem = new OpportunityLineItem();
    oppLineItem.TotalPrice = 10;
    
    uow.registerNew(oppLineItem, OpportunityLineItem.OpportunityId, opp);
  }

  uow.commitWork();
}
```

No maps, and no direct DML.

<br>

### `registerNew` and `registerRelationship`

- Allow you to see into the future
- Register relationships without knowing the Id’s of records your inserting
- Delegating this logic, we can avoids managing lists and maps.

```java
Product2 product = new Product2();
PricebookEntry pbe = new PricebookEntry();
OpportunityLineItem oppLineItem = new OpportunityLineItem();

uow.registerNew(pbe, PricebookEntry.Product2Id, product);
uow.registerRelationship(oppLineItem, OpportunityLineItem.PricebookEntryId, pbe);
```

The `registerNew` will insert a record and with it's overloaded method we can reference the parent record as well.

With `registerRelationship` we setup a relationship between two records that have yet to be inserted to the database (with the use of *lookup* field).

<br>

### `registerDirty`

Is used to register an existing record to be updated during the commitWork method.

```java
for(Opportunity opportunity : opportunities)
{
  opportunity.Description = 'Consolidated on ' + System.today();
  uow.registerDirty(opportunity);
}

uow.commitWork();
```

<br>

### `registerDeleted`

Should be used when we want to deleted an existing record.

```java
for(OpportunityLineItem lineForProduct : linesForGroup)
{
  uow.registerDeleted(lineForProduct);
}

uow.commitWork();
```

<br>

### UOW manages relationships between parent and child records
- Since the UOW only holds records until the end of the Service method and the call to the `commitWork()` method, it needs to maintain the “connection” between parent and child records.
- The `registerRelationship` series of methods accomplish this.
- Reference line 54 of the `InvoicingServiceTest.cls` class.
  - The parent Opportunity record is registered at line 39, but not saved to database yet
  - Each of the child `OpportunityLineItem` records are
    - Registered as new records to be saved at line 55
    - Related to the parent Opportunity record at line 54 using the `registerRelationship` method
- During the `commitWork()` method execution, the UOW saves the parent Opportunity records, maintains a link to the new opportunity record id, and then adds that parent record id to the child OpportunityLineItem records before saving those new records.

<br><br>
---

### References
- [Managing your DML and Transactions with a Unit Of Work](https://andyinthecloud.com/2013/06/09/managing-your-dml-and-transactions-with-a-unit-of-work/)
- [Doing more work with the Unit Of Work](https://andyinthecloud.com/2014/07/17/doing-more-work-with-the-unit-of-work/)
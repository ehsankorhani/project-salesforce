# Unit Of Work Pattern

When saving two related objects we need to save the parent first in order to get the Ids. With *Unit of Work* the developer does not need to think about the relationship order or performing separate 
DMLs for each.

Unit of Work manages all DML transactions and their rollbacks.

It is a “utility” class focused on:

- Optimizing DML interactions with the Database layer
- Providing transactional control for the Service Layer
- Simplifying the complex code usually constructed to manage bulkified DML operations
- Managing the “plumbing” needed to save parent-child data relationships

<br>

## Usage

- Used within a service method but passed to domain methods as needed.
- Using an instance of UOW, you can register new records, modified/dirty records, and register records that need to be deleted.
- Once all records and changes are collected, the `commitWork()` method is called to begin DML transactions.

<br>

## Create an instance of a Unit Of Work

The Apex class `Application` exposes a static property and method to create an instance of a Unit Of Work.

```java
public static final fflib_Application.UnitOfWorkFactory UnitOfWork = new fflib_Application.UnitOfWorkFactory(
				new List<SObjectType> { 
					Driver__c.SObjectType,
					Season__c.SObjectType,
					Race__c.SObjectType,
					Contestant__c.SObjectType
          });
```

Then we use the `fflib_ISObjectUnitOfWork` interface to create the new instance:

```java
fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
```

And then *register* the object to be saved:

```java
// Create Driver__c records
Map<String, Driver__c> driversById = new Map<String, Driver__c>();

for (DriverDatadriverData : seasonsData.drivers) {
  Driver__c driver = new Driver__c(Name = driverData.name, DriverId__c = driverData.driverId, Nationality__c = driverData.nationality,  TwitterHandle__c = driverData.twitterHandle);

  uow.registerNew(driver);
  driversById.put(driver.DriverId__c, driver);
}

for (SeasonDataseasonData : seasonsData.seasons) {
  // Create Season__c record
  Season__c season = new Season__c(Name = seasonData.year, Year__c = seasonData.year);
  uow.registerNew(season);

  for (RaceDataraceData : seasonData.races) {
    // Create Race__c record
    Race__c race = new Race__c(Name = raceData.name);
    uow.registerNew(race, Race__c.Season__c, season);

    for (ContestantDatacontestantData : raceData.contestants) {
      // Create Contestant__c record
      Contestant__c contestant = new Contestant__c(ChampionshipPoints__c = contestantData.championshipPoints, DNF__c = contestantData.dnf,
      Qualification1LapTime__c = contestantData.qualification1LapTime, Qualification2LapTime__c = contestantData.qualification2LapTime,
      Qualification3LapTime__c = contestantData.qualification3LapTime);

      uow.registerNew(contestant, Contestant__c.Race__c, race);
      uow.registerRelationship(contestant, Contestant__c.Driver__c, driversById.get(contestantData.driverId));
    }
  }
}

// Insert records registered with uow above
uow.commitWork();
```

### Documentation

- `registerNew(SObject record)`
  Register a newly created SObject instance to be inserted.
- `registerNew(SObject record, Schema.SObjectField relatedToParentField, SObject relatedToParentRecord)`
  Register a newly created SObject instance with a reference to the parent record instance (should also be registered as new separately).
- `registerRelationship(SObject record, Schema.SObjectField relatedToField, SObject relatedTo)`
  Register a relationship between two records that have yet to be inserted to the database.
  `relatedTo` is a SObject instance that is yet to be committed to the database.

- `registerUpsert(List<SObject> records)`
  Register a list of mix of new and existing records to be inserted updated

- `registerDirty(SObject record)`
  Register an existing record to be updated
- `registerDirty(SObject record, List<SObjectField> dirtyFields)`
  Registers the entire record as dirty or just only the dirty fields if the record was already registered.

<br>

## The Unit Of Work scope

It is recommended to maintain a single instance of the Unit Of Work within the scope of the service method.
Pass Unit Of Work instance to other Service methods rather than allowing them to create their own instance.

<br>

## Considerations

The following are not supported and should be done in a custom way:

- **Self and recursive referencing**: for example, account hierarchies.
- **More granular DML operations**: UOW is all or nothing.
- **Sending emails**: Sending emails is considered a part of the current transaction.

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
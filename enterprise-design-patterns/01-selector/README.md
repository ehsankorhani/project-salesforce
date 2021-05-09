# Selector Pattern

The Selector, based on Mapper pattern, aims to encapsulate the SOQL query logic, making it easy to access, maintain, and reuse such logic throughout the application.

- A class responsible for all aspects of queries for a single `SObject`
- Manages the fields to query
- Manages the specific queries
- All classes use this class to make queries against this SObject
- The pattern encourages bulkification
  - All method parameters are usually Sets of `ID`s
  - All methods return Lists of the `SObject`
- Returns List of `SObjects` or `Database.QueryLocator`

A good practice is to always define the Selector classes with: `inherited sharing`

<br>

### Cons of static queries

- Difficult to maintain
  - If a new field is needed, developer has to change every instance in codebase
- Prevent "SObject row was retrieved via SOQL without querying the requested field" error
- Violates *Separation of Concerns* principle

<br>

### Naming convention

- Optional "section" prefix which denotes a module/application with underscore.
  - i.e. `eks_`
- Begins with `SObject` in plural form.
  - i.e. `Opportunities`
- Ends with `Selector`.
- Multi-SObject query support
  - i.e. `OpportunitiesSelector.selectByIdWithProducts(Set<ID> idSet)`
- Default set of classes
  - i.e. SObject = `FooBar__c`
    - `FooBarsSelector`
    - `IFooBarsSelector`
    - `FooBarsSelectorTest`
    - `FooBarsSelectorException`

- **Class names**: plural name of the object it is associated with and appending the word Selector at the end. You can group common cross-object queries into a single module scoped class
  - bad examples: `RaceSOQLHelper` and `SOQLHelper`.
  - good examples: `RacesSelector`, `DriversSelector`, and `RacingAnalyticsSelector`.
- **Method names**: express the shared purpose of the Selector methods, followed by a description of the primary criteria and/or relationships used.
  - bad examples: `getRecords`, `getDrivers`, `loadDrivers`, `selectDriversById`, `selectRacesAndContestants`.
  - good examples: `selectById`, `selectByTeam`, `selectByIdWithContestants`, and
`selectByIdWithContestantsAndDrivers`.
- **Method signatures**: Selector methods typically return a Map, List, or QueryLocator method. Method parameters reflect the parameterized aspects of the WHERE clause and should be bulkified.
  - bad examples: `selectById(Id recordId)`, `DriverSelector.select(Set<Id> teamIds)`, `Database.QueryLocatorqueryForBatch(Set<Id> ids)`
  - good examples: `selectById(Set<Id> raceIds)`, `selectByTeam(Set<Id> teamIds)`

<br>

### Record order consistency

By using a Selector, you can apply a default order sequence to all Selector methods.

<br>

### Querying fields consistently

Rather than repeating queries for the same record solely to query different fields, it is desirable to factor code such that it can pass the queried data as parameters from one method to another.

<br>
<br>

## The Selector class template

The Selector class extends `fflib_SObjectSelector` to gain some standard functionality.

Classes to maintain in the "fflib-apex-common" project:
- `fflib_QueryFactory`
  - Facilitates an object oriented way to construct queries efficiently
- `fflib_SObjectSelector`
  - Abstract base class for all selector pattern classes within the application
- `fflib_ISObjectSelector`
  - Base Interface used by all selector pattern classes
  - All individual selector interfaces extend this interface

A basic example of a Selector class:

```java
public inherited sharing class RacesSelector extends fflib_SObjectSelector {
  public List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField> {
      Race__c.Id,
      Race__c.Name,
      Race__c.Status__c,
      Race__c.Season__c,
      Race__c.FastestLapBy__c,
      Race__c.PollPositionLapTime__c,
      Race__c.TotalDNFs__c };
  }

  public Schema.SObjectTypegetSObjectType() {
    return Race__c.sObjectType;
  }
}
```

Or:

```java
public class OpportunitiesSelector extends fflib_SObjectSelector implements IOpportunitiesSelector {
 
   public Schema.SObjectType getSObjectType() {
      return Opportunity.sObjectType;
   }
 
   public override List<Schema.SObjectField> getSObjectFieldList() {
      return new List<Schema.SObjectField> {
         Opportunity.AccountId,
         Opportunity.Id,
         Opportunity.Name,
         Opportunity.StageName
      };
   }
 
}
```

A typical method in Selector class would be like:

```java
public List<Opportunity> selectById(Set<Id> recordIds) {
   return (List<Opportunity>) selectSObjectsById(recordIds);
}
```

The methods can be used as:

```java
List<Race__c> races = (List<Race__c>) new RacesSelector().selectSObjectsById(raceIds);
```

The above method will dynamically create the following SOQL:

```sql
SELECT Name, TotalDNFs__c, Status__c, Season__c, Id, PollPositionLapTime__c, FastestLapBy__c
FROM Race__c
WHERE id in :idSet ORDER BY Name
```

<br>

### Documentation

- Abstract `getSObjectType` <br>
  Tells the base class which SObject is being described.
- Abstract `getSObjectFieldList` <br>
  Returns a list of common fields used when build queries are used in this selector class.
- Public `selectSObjectsById` <br>
  Executes a dynamically generated SOQL query that selects the fields specified by the getSObjectFieldList method.
- Virtual `getOrderBy` <br>
  Optionally override this to change the default order by applying to queries generated or executed by the base class.
- Virtual `getSObjectFieldSetList` <br>
  Optionally provide a list of Field Sets for the base class query generator to consider when generating a list of fields to query.
- Public `newQueryFactory` <br>
  Provides an object-oriented means to further customize the queries generated by the base class before executing them.

<br>
<br>

## Implementing the standard query logic

In order to avoid casting the object by the caller we can convert the type before returning it:

```java
public List<Race__c> selectById(Set<Id>raceIds){
  return (List<Race__c>) selectSObjectsById(raceIds);
}
```

<br>

### Standard features of the Selector base class

We can extend the behavior of `fflib_SObjectSelector`.

```java
public inherited sharing abstract class ApplicationSelector extends fflib_SObjectSelector
{
  // Add your common methods here
}

public class RacesSelector extends ApplicationSelector
{
  // Methods using methods from both base classes
}
```

<br>

### Enforcing object and field-level security

By default, the base class methods in the `fflib_SObjectSelector` base class automatically perform **object read** security.

The ability of the base class to enforce field-level read security is also available but is not enforced by default.

```java
public inherited sharing abstract class ApplicationSelector extends fflib_SObjectSelector {

  public ApplicationSelector() {
    this(false);
  }

  public ApplicationSelector(Boolean includeFieldSetFields) {
    // Disable the default base class read security checking
    // in preference to explicit checking elsewhere
    this(includeFieldSetFields, false, false);
  }
  public ApplicationSelector(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS) {
    // Disable sorting of selected fields to aid debugging
    // (performance optimization)
    super(includeFieldSetFields, enforceCRUD, enforceFLS, false);
  }
  
}
```

<br>

### Ordering

The default behavior is to use the `Name` field (if available, otherwise `CreatedByDate` is used).

Override this method to provide a different ordering:

```java
public override String getOrderBy() {
  return 'Race__r.Season__r.Name, Race__r.Name, RacePosition__c';
}
```

<br>

### Field Sets

The additional Custom Fields added to the subscriber org still need to be queried in order for them to be displayed.

Override the `getSObjectFieldSetList` method and construct the Selector with the includeFieldSetFields parameter.

<br>


### Multi-Currency

You have the option to reference this field using Dynamic Apex and Dynamic SOQL.

<br>
<br>

## Implementing the custom query logic

The `newQueryFactory` method exposes an alternative object-orientated way to express a SOQL query.

```java
public List<SObject> selectSObjectsById(Set<Id> idSet) {
  return Database.query(buildQuerySObjectById());
}

private String buildQuerySObjectById() {
  return newQueryFactory().setCondition('id in :idSet').toSOQL();
}
```

The `toSOQL` method returns the actual SOQL query string that is passed to the standard Database.query method.

A basic custom Selector method:

```java
public List<Driver__c> selectByTeam(Set<Id>teamIds) {
 return (List<Driver__c>) Database.query(newQueryFactory()
                                    .setCondition('Team__c in :teamIds')
                                    .toSOQL());
}
```

<br>

A custom Selector method with subselect:

```java
public List<Race__c> selectByIdWithContestants(Set<Id> raceIds) {
  fflib_QueryFactory racesQueryFactory = newQueryFactory();
  fflib_QueryFactory contestantsSubQueryFactory = new ContestantsSelector().addQueryFactorySubselect(racesQueryFactory);

  return (List<Race__c>) Database.query(racesQueryFactory.setCondition('Id in :raceIds').toSOQL());
}
```

Which generates:

```sql
SELECT Name, TotalDNFs__c, Status__c, Season__c, Id, PollPositionLapTime__c, FastestLapBy__c,
  (SELECT Qualification1LapTime__c, ChampionshipPoints__c, Driver__c, GridPosition__c, Qualification3LapTime__c, RacePosition__c, Name, DNF__c, RaceTime__c,  Id, DriverRace__c, Qualification2LapTime__c, Race__c
  FROM Contestants__r
  ORDER BY Race__r.Season__r.Name, Race__r.Name, RacePosition__c)
FROM Race__c
WHERE id IN :raceIds ORDER BY Name
```

<br>

A custom Selector method with related fields:

```java
public List<Contestant__c>selectByIdWithDriver(Set<Id>driverIds) {
 fflib_QueryFactory contestantFactory = newQueryFactory();

 new DriversSelector().configureQueryFactoryFields(contestantFactory, Contestant__c.Driver__c.getDescribe().getRelationshipName());

 return Database.query(contestantFactory.setCondition('Id in :driverIds').toSOQL());
}
```

<br>

### SelectorFactory methods

Has two methods on it: `newInstance` and `selectById`.

```java
List<Contestant__c> contestants = Application.Selector.selectById(contestantIds);
```
```java
 List<Contestant__c> contestants = Application.Selector.newInstance(Contestant__c.SObjectType).selectSObjectsById(contestantIds);
```

`selectById` method provides a shortcut to access the generic `selectSObjectById` method.

<br>
<br>

## Introducing the Selector factory

<br>
<br>

### Minimum setup of a class
- Extends `fflib_SObjectSelector`
- Implements the corresponding interface
  - to support mocking
- Implements following methods:
  - `Schema.SObjectType getSObjectType()`
    - Allows the framework to understand on which SObject this selector provides
  - `List<Opportunity> selectById(Set<ID> idSet)`
  - `List<Schema.SObjectField> getSObjectFieldList()`
    - To guarantee every query that utilizes ths class will always have these fields
  - `static IOpportunitiesSelector newInstance()`
    - calls the `Application.Selector.newInstance(Opportunity.SObjectType)` and casts the instance to the ISelector interface

<br>

### Selector class
- Each selector class manages its own SObject
- Each section of query is built from `fflib_QueryFactory`
- Method relies on other selector classes for multi-object query:
  - `fflib_QuerySelector.addQueryFactorySubselect()`
  - `fflib_QuerySelector.configureQueryFactoryFields()`

```java
// OpportunitiesSelector.cls

// ...

	public List<Opportunity> selectByIdWithProducts(Set<Id> idSet)
	{
		fflib_QueryFactory opportunitiesQueryFactory = newQueryFactory();

		fflib_QueryFactory lineItemsQueryFactory = new OpportunityLineItemsSelector().addQueryFactorySubselect(opportunitiesQueryFactory);
			
		new PricebookEntriesSelector().configureQueryFactoryFields(lineItemsQueryFactory, 'PricebookEntry');
		new ProductsSelector().configureQueryFactoryFields(lineItemsQueryFactory, 'PricebookEntry.Product2');
		new PricebooksSelector().configureQueryFactoryFields(lineItemsQueryFactory, 'PricebookEntry.Pricebook2');

		return (List<Opportunity>) Database.query(opportunitiesQueryFactory.setCondition('id in :idSet').toSOQL());
	}

// ...
```

Usage:
```java
// Query Opportunities
List<Opportunity> oppRecords = OpportunitiesSelector.newInstance().selectByIdWithProducts(opportunityIds);
```

<br>

![Selector Pattern](./../img/selectors.png "Selector Pattern")

<br>

Notes:
- Selectors only access other selectors during multi-object relationship queries
- Selectors never access domains, service-tier logic, nor client-tier logic 

<br><br>
---

### References
- [FFLIB – Selector layer](https://quirkyapex.com/2016/08/18/fflib-selector-layer/)
- [FFLib Apex Common Sample](https://github.com/apex-enterprise-patterns/fflib-apex-common-samplecode)
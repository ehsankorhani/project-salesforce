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

### UOW manages relationships between parent and child records
- Since the UOW only holds records until the end of the Service method and the call to the `commitWork()` method, it needs to maintain the “connection” between parent and child records.
- The `registerRelationship` series of methods accomplish this.
- Reference line 54 of the `InvoicingServiceTest.cls` class.
  - The parent Opportunity record is registered at line 39, but not saved to database yet
  - Each of the child `OpportunityLineItem` records are
    - Registered as new records to be saved at line 55
    - Related to the parent Opportunity record at line 54 using the `registerRelationship` method
- During the `commitWork()` method execution, the UOW saves the parent Opportunity records, maintains a link to the new opportunity record id, and then adds that parent record id to the child OpportunityLineItem records before saving those new records.
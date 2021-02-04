# Apex Enterprise Design Patterns

## Table on Contents
0. Introduction
1. Selector Pattern
2. Domain Pattern
3. Service Pattern
4. Application Factory Pattern
5. Unit Of Work Pattern

<br>

## Introduction

Represent best practices for large scale development projects.

It based on "*Patterns of Enterprise Application Architecture*" by Martin Fowler and wad first adapted by Andy Fawcett in "*Salesforce Lightning Platform Enterprise Architecture*".

The open source project framework created by FinancialForce, and included:
- FFLIB Apex Mocks
  - Unit testing with Stub API support
- FFLIB Apex Commons
  - Supports implementation of various design patterns

### Principles
- Separation of Concerns
- DRY principle
- SOLID principle
- Dependency Injection

<br>

### Separation of Concerns

Organizing the code so it has a specific responsibility. No code should have more than one responsibility.

Typical layers:
- **Presentation Layer**
  - Declarative: Lightning UI/LEX, Page layouts, Reports, Dashboards, Screen Flow Types
  - Programmatic: Lightning Web Components, Aura, Single Page Apps, Visualforce
- **Business Logic Layer**
  - Declarative: Certain elements of Flows and Process Builders, Approval Processes
  - Programmatic: Apex
- **Data Access Layer**
  - Declarative: Flow Data Elements – Create Records, Update Records, Get Records, etc.
  - Programmatic: SOQL, SOSL, Salesforce REST and SOAP APIs
- **Database Layer**
  - Declarative: Custom Objects, Fields, Relationships, Autolaunched Flow Types
  - Programmatic: Apex Triggers


### DRY (Don't Repeat Yourself)
Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.

### SOLID
- Single-responsibility principle
- Open-closed principle
- Liskov substitution principle
- Interface segregation principle
- Dependency inversion principle

<br>

## FFLIB Apex Common Framework

Five key elements:
- Selectors
- Domains
- Services
- Unit Of Work
- Application Factory

<br><br>
---

### References

- Salesforce Lightning Platform Enterprise Architecture - Andrew Fawcett
- [Salesforce Lightning Platform Enterprise Patterns | Apex Enterprise Patterns](https://www.youtube.com/watch?v=Vl5sQ8vECdk)
- [Apex Enterprise Patterns](http://www.apexhours.com/apex-enterprise-patterns/)
- [GitHub - Apex Enterprise Patterns Open Source](https://github.com/apex-enterprise-patterns)

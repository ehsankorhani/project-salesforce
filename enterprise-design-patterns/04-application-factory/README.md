# Application Factory Pattern

Orchestrates the assembly and mappings of the loosely coupled services, domains, and selectors.
Because of these loose coupling the implementations can be swapped with one another (makes it easier to mock objects).

- All instantiations of selectors, domains, services, and UOWs are handled by this class
- A single Application class is defined which statically maps:
  - SObject to selector classes
  - SObject to domain classes
  - Service Interfaces to Service Implementations
  - SObjects that the UOW is designed to work with and listed in DML execution order

<br>

### Classes to mention in the *fflib-apex-common* project
- `fflib_Application.cls`
  - `fflib_Application.UnitOfWorkFactory()`
    - UOW Manages all the complexities around saving objects and relationships.
    - The order of SObjects in this list defines the sequence of savings.
  - fflib_Application.ServiceFactory()
    - Maps services to implementations
  - fflib_Application.SelectorFactory()
    - Bind SObjects to selectors
  - fflib_Application.DomainFactory()
    - Bind SObjects to domains

<br>

### Examples in *fflib-apex-common-samplecode* project
- `Application.cls`

<br>

### Naming convention
- Optional "section" prefix - which denotes a module/application with underscore.
- Single Apex class named "Application"

<br>

### Minimum setup of Application Factory class
- Simple class
- Defines four static final methods

<br>

**Notes**:<br>
The various `fflib_Application` factories (i.e. UnitOfWorkFactory, ServiceFactory, SelectorFactory, and DomainFactory) each have a "setMock" method.
- Allows unit tests to replace the default implementation of a selector, domain, service, or OUW with a mocked version.
- Key to the ApexMocks implementation and benefits of proper separation of concerns setup.
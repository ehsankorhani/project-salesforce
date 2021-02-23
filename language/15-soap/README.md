# SOAP Web Services

SOAP is an XML-based protocol for accessing web services over HTTP.

We Use the `webservice` keyword to define the method that enables us to expose a custom SOAP Web service calls. The external application can invoke an Apex Web service to perform an action in Salesforce.

```java
global class MyWebService {
    webservice static Id makeContact(String contactLastName, Account a) {
        //...
        return contactId;
    }
}
```

The consumer of the `webservice` requires a `WSDL` for the class.

This can be done by opening the Apex Class in Salesforce Setup and clicking **Generate WSDL**.

<br>

### Security and Permission

The `webservice` methods run in *system context*. User's permissions or field-level security have no affect on the outcome.

However, sharing rules (record-level access) can be enforced with `with sharing` keyword.

<br>

### Considerations

- `webservice` keyword cannot be used to define a class or an inner class method.
- All classes that contain methods defined with the webservice keyword must be declared as `global`.
- `webservice` keyword makes methods global as well.
- Methods should be `static`.
- Apex does not allow two methods marked with the webservice keyword to have the same name (overloaded).
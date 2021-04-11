# Annotations

With annotations we can modify the way that a method or class behaves.

<br>

### `@AuraEnabled`

Exposes the methods to Lightning web components and Aura components.

In addition we can enable client-side caching with `@AuraEnabled(cacheable=true)` on READ methods.

```java
@AuraEnabled(cacheable=true)
public static Account getAccount(Id accountId) {
    // your code here
}
```

<br>

### `@Deprecated`

New subscribers to the *managed package* cannot see the deprecated methods, classes, exceptions, enums, interfaces, or variables, while the elements continue to function for existing subscribers and API integrations.

```java
@deprecated
// This method is deprecated. Use myOptimizedMethod(String a, String b) instead.
global void myMethod(String a) { }
```

<br>

### `@Future`

To identify methods that are executed asynchronously. Without `future`, the Web service callout is made from the same thread that is executing the Apex code

Methods with the future must be:

- static methods
- void type
- parameters must be primitive data types, arrays of primitive data types, or collections of primitive data types

```java
global class MyFutureClass {
 
  @future 
  static void myMethod(String a, Integer i) {
    System.debug('Method called with: ' + a + ' and ' + i);
    // Perform long-running code
  }

  @future (callout=true)
  public static void doCalloutFromFuture() {
    // Add code to perform callout
  }
}
```

<br>

### `@InvocableMethod`

Invocable methods are used to invoke a single Apex method.

```java
public with sharing class GetFirstFromCollection {
  @InvocableMethod(label='...' description='...' category= '...')
  public static List<Results> execute (List<Requests> requestList) {
    List<SObject> inputCollection = requestList[0].inputCollection;
    //...  
  }
}
 
public class Requests {
  @InvocableVariable(label='Records for Input' description='yourDescription' required=true)
  public List<SObject> inputCollection;
  }
 
public class Results {
  @InvocableVariable(label='Records for Output' description='yourDescription' required=true)
  public SObject outputMember;
  }
}
```

### Supported Modifiers

All modifiers are optional.

- **label**: Appears as the action name in Flow Builder.
- **description**: Appears as the action description in Flow Builder.
- **callout**: Whether the method makes a call to an external system (`callout=true`).
- **category**: Appears as the action category in Flow Builder.
- **configurationEditor**: The custom property editor that is registered with the method.

#### Considerations

Implementation Notes:

- Must be static and public or global, and its class must be an outer class.
- Only one method in a class can have the *InvocableMethod* annotation.
- Other annotations can’t be used with the InvocableMethod annotation.
- There can be at most one input parameter and its data type 
- Return type is either null or of allowed types.
- Only global invocable methods appear in Flow Builder and Process Builder in the subscriber org.

<br>

### `@InvocableVariable`

<br>

### `@IsTest`

<br>

### `@JsonAccess`

<br>
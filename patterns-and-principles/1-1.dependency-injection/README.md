# Dependency Injection

A dependency is an object that another object depends on.

For instance, we can have a Selector class as:

```java
public class MySelector
{
    //...

    public List<Account> getAccounts()
    {
        return (List<Account>) Database.query(newQueryFactory().toSOQL());
    }
}
```

And a Service class which directly depends on it:

```java
public class MyService {

    private MySelector mySelector;

    public MyService() {
        this.mySelector = new MySelector();
    }

    public void doSomething() {
        // ...
        List<Account> account = this.mySelector.getAccounts();
        // ...
    }
}
```

It is not possible to unit-test such a class because it has hard and concrete dependency on another functionality.

<br>

## Decoupling code in Apex

How is it possible to decouple the dependency to `MySector` class?

<br>

### 1. Constructor Injection

The class will receive it's dependencies via the constructor.

```java
public class MyService {

    private IMySelector mySelector;

    public MyService(IMySelector mySelector) {
        this.mySelector = mySelector;
    }

    public void doSomething() {
        // ...
        List<Account> account = this.mySelector.getAccounts();
        // ...
    }
}
```

<br>

### 2. Using an IOC container

The class dependencies will be received via an IOC container. During the testing phase, the IOC container can be instructed to return the mock instance.

```java
public class MyService {

    public void doSomething() {
        // ...
        IMySelector mySelector = Container.instance.get(IMySelector.class);
        List<Account> account = mySelector.getAccounts();
        // ...
    }
}
```

<br>

### 3. Using @TestVisible on Private Properties

The class defines it's dependency using a `private` property.

```java
public class MyService {

    @TestVisible
    private static MySelector mySelector = new MuSelector();

    public void doSomething() {
        // ...
        List<Account> account = mySelector.getAccounts();
        // ...
    }
}
```

This can be replaced with the mock instance by the unit test method.

```java
public class MyServiceTest {

    public void testDoSomething() {
        // Arrange
        MySelector mySelectorMock = ...
        MyService.mySelector = mySelectorMock;

        // Act
        MyService.doSomething();
    }
}
```

<br>

---

### References

- [Leonardo Berardino - Mocking Apex Tests](https://youtu.be/ks6segNG0YI)
- [Overview of dependency injection](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-5.0#overview-of-dependency-injection)
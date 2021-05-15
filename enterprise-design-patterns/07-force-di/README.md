# Force-DI

- Decoupling dependencies for flexible app design
- In true decoupling the App should never know which implementation it's going to use.


### Tight coupling

```java
public class ChatApp {

    public String greetings() {
        if (UserAvailability__c.getInstance().OUtOfOffice__c) {
            return new VacationMessage().sayOutOfOffice();
        } else {
            return new WorkingMessage().sayInTheOffice();
        }
    }

}

public class WorkingMessage {
    public String sayInTheOffice() {
        return 'HI, I am in the office today';
    }
}

public class VacationMessage {
    public String sayOutOfOffice() {
        return 'Hi, I am out of the office today';
    }
}
```

### Introduce Interface

Move logic of which implementation to use, which decouples the greetings method from the message provider.

```java
public class ChatApp {

    private IMessage message { get; set; }

    public ChatApp() {
        if (UserAvailability__c.getInstance().OUtOfOffice__c) {
            message = new VacationMessage();
        } else {
            message = new WorkingMessage();
        }
    }

    public String greetings() {
        return this.message.saySomething();
    }
}


public interface IMessage {
    String saySomething();
}

public class WorkingMessage implements IMessage {
    public String saySomething() {
        return 'HI, I am in the office today';
    }
}

public class VacationMessage implements IMessage {
    public String saySomething() {
        return 'Hi, I am out of the office today';
    }
}
```

#### Decoupling

Injecting the implementations to use at runtime, completely decoupling the classes.

Either passing in the class to use or looking it up in real-time.

```java
public class ChatApp {

    private IMessage message { get; set; }

    public ChatApp(IMessage message) {
        this.message = message;
    }

    public ChatApp() {
        this.message = di_Injector.Org.getInstance(IMessage.class);
    }

    public String greetings() {
        return this.message.saySomething();
    }
}
```

The implementation classes now could live in separate packages or namespaces than ChatApp.

Use Custom Metadata to wire up which IMessage impl class to inject at runtime via DI.

The `di_Injector` will look at a configuration - custom metadata.
1. In Org Custom Metadata we go to "Binding"
2. Create New Record
3. Label + Binding Name = ChatAppMessage
    Type = Apex (in this case/example)
    To = VacationMessage
4. Save

When calling the constructor injection method we can also do it in tow types:

1. Hard Code
```java
IMessage message = new VacationMessage();
ChatApp app = new ChatApp(message);
System.debug(app.greetings());
```

2. Dynamic Lookup (preferred)
```java
IMessage message = (IMessage)di_Injector.Org.getInstance('ChatAppMessage');
ChatApp app = new ChatApp(message);
System.debug(app.greetings());
```

To make this even more dynamic, we can delegate the decision of what type to inject to a Module. In the Binding Custom Metadata do:
1. Label + Binding Name = ChatAppModule
    Type = Module (instead of Apex)
    To = ChatAppModule
2. Save
 
The `ChatAppModule` class extends `di_Module` to make a configuration that we want dynamically at run time:

```java
public with sharing class ChatAppModule extends di_Module {

    public override void configure() {

        Integer count = [
            SELECT
                COUNT()
            FROM
                OutOfOffice
            WHERE
                UserId = :UserInfo.getUserId()
                AND
                IsEnabled = true
        ];

        if ( count > 0 ) {
            bind('ChatAppMessage').to(VacationMessage.class);
        } else {
            bind('ChatAppMessage').to(WorkingMessage.class);
        }

        // logic to add more bindings if desired
    }

}
```



---

### References

- [RVA Salesforce User Group - Dependency Injection, Flows, and Force DI](https://youtu.be/YzaI5Ddfwkg)
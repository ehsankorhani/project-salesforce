# Event Driven Development

## What is Event Driven development?

The main idea is to decouple point to point integrations and create a more real-time notifications through Publishing & Subscribing.

In contrast, in Request/Response pattern we send messages and data to a single known destination (i.e. a REST API endpoint).

However, a **Publisher** can pass a message to an **Event Bus/Browser** and through that to multiple Subscribers without having hard dependencies on them.

![Publish/Subscriber Pattern](./img/realtimeapi.io.pubsub-1.png "Publish/Subscriber Pattern - Realtimeapi.io")

<br>

## Event driven development in Salesforce

- **Browser Events**: using JavaScript event loop to communicate across a web page in
  - Lightning components
- **Platform Events**: using Pub/Sub approach and event bus to communicate to external systems.
  - Flow
  - API
  - Apex
  - Lightning components
- **WebSockets**: streaming service to work with large amount of data.
  - Lightning components

<br>

## Browser Events

When the event is created (i.e. mouse move, button click, etc.), a request will be sent to the browser **Event Loop** and then operation will be performed. Upon fulfillment of the action a Callback will be sent back indicating the result.

In the publisher components we can create and dispatch an event in this way:

```js
messageText = '';

// change messageText in some event or function
// create the event in another event

const event = new CustomEvent('message', {
  detail: {
    value: this.messageText
  },
  bubbles: true
});

this.dispatchEvent(event);
```

### Run Code When a Component Is Inserted or Removed from the DOM

We want the event listener to only created when the component is inserted into the DOM and we must remove the listener when it is removed.

- `connectedCallback()` lifecycle hook fires when a component is inserted into the DOM.
- `disconnectedCallback()` lifecycle hook fires when a component is removed from the DOM.

```js
receivedMessage = '';

connectedCallback() {
  window.addEventListener('message', this.handleMessage, false);
}

handleMessage = (e) => {
  this.receivedMessage = e.detail.value;
}

disconnectedCallback() {
  window.removeEventListener('message', this.handleMessage, false);
}
```

<br>

## Lightning Messaging Service

Takes the same concept of JavaScript creating custom-events and subscriptions, but funnels them through a channel.

One component can define a message and pass it through a channel - instead of through the standard event protocol.

Benefit of using channel is that it's going to be more secure because we have to subscribe to the channel specifically in order the receive the event.

### Message Channels

The message is defined in XML. It has to be created manually.

We can create a new folder at this path:

```bash
force-app/main/default/messageChannels
```

and build our channel with `.messageChannel-meta.xml` extension:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<fieldName>messageText</fieldName>

<LightningMessageChannel xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>SampleMessageChannel</masterLabel>
    <isExposed>true</isExposed>
    <lightningMessageFields>
        <description>Holds the message to display</description>
    </lightningMessageFields>
</LightningMessageChannel>
```

In the JS file, we need to import the channel from Salesforce:

```js
// publisher
import CHANNEL_NAME from '@salesforce/messageChannel/Channel_Name__c';
import {publish, createMessageContext} from 'lightning/messageService'
```
The "Channel_Name__c" is the name of the channel file.

Secondly, we will use the `createMessageContext()` to open up LMS on the component. Alternatively, we can import the context with:

```js
import {MessageContext} from 'lightning/messageService'
```

and `wire` it:

```js
@wire(MessageContext)
  messageContext;
```

And then, we can publish or subscribe to it.

```js
// publisher
doSomething() {
  const payload = {};
  publish(this.context, CHANNEL_NAME, payload);
}
```

In the Subscriber, we should import the Channel:

```js
// subscriber
import messageChannel from '@salesforce/messageChannel/Sample__c';
import { subscribe, createMessageContext } from 'lightning/messageService';
```

or we can import a MessageContext and `@wire` it.

The `subscriber` object will be created in the `connectedCallback()` hook:

```js
// subscriber

context = createMessageContext();

connectedCallback() {
  this.handleSubscribe();
}

handleSubscribe() {
  if (this.subscription) {
    return;
  }
  this.subscription = subscribe(this.context, messageChannel, (message) => {
    this.messageText = message.messageText;
  });
}
```

<br>

## Platform Events

> Pub/Sub and Event Bus in Salesforce

Platform events are defined in a very similar way to Custom Objects.

Step to creating an event:
1. Setup -> Integrations -> Platform Events
2. New Platform Event
3. Define the Name and Custom Fields

<br>

### 

---

### References
- [Stephan Chandler-Garcia - Event driven development on Salesforce - Apex Hours](https://youtu.be/qv0AeFlUJ3o)
- [Run Code When a Component Is Inserted or Removed from the DOM](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.create_lifecycle_hooks_dom)
- [Introduction to Lightning Message Service](https://www.soliantconsulting.com/blog/lightning-message-service/)
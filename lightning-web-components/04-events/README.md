# Communicate with Events

- Components can create and dispatch custom events.
- Use events to communicate up the component containment hierarchy.

<br>

## Create and Dispatch Events

- `CustomEvent()`: to create an event
  - takes an string argument indicating the event type (name)
- `EventTarget.dispatchEvent()`: to dispatch an even

```html
<!-- paginator.html -->
<template>
    <lightning-button label="Next" icon-name="utility:chevronright" icon-position="right" onclick={nextHandler}></lightning-button>
</template>
```

When user clicks the button **Next** the components creates and dispatches **next** event.

```js
// paginator.js
import { LightningElement } from 'lwc';

export default class Paginator extends LightningElement {
    nextHandler() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}
```

The owner of the `paginator` component can listen to it's events with syntaxt: `oneventtype`.

```html
<!-- eventSimple.html -->
<template>
    <c-paginator onnext={nextHandler}></c-paginator>
</template>
```

<br>

### Pass Data in an Event

- Set a `detail` property in the `CustomEvent` constructor
- Must send primitive data (otherwise can be mutated by the receiver)

```js
// contactListItem.js
import { LightningElement, api } from 'lwc';

export default class ContactListItem extends LightningElement {
    @api contact;

    selectHandler(event) {
        // Prevents the anchor element from navigating to a URL.
        event.preventDefault();

        // Creates the event with the contact ID data.
        const selectedEvent = new CustomEvent('selected', { detail: this.contact.Id });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}
```

<br>

---

<br>
<br>

## Handle Events

Listen for an event:

1. Declaratively from the component’s HTML template (recommended)
2. Programmatically using an imperative JavaScript API

<br>

### Attach an Event Listener Declaratively

Declare the listener in markup:

```html
<!-- parent.html -->
<template>
    <c-child onnotification={handleNotification}></c-child>
</template>
```

<br>

### Attach an Event Listener Programmatically

Define both the listener and the handler function:

```js
// parent.js
import { LightningElement } from 'lwc';
export default class Parent extends LightningElement {
  constructor() {
    super();
    this.template.addEventListener('notification', this.handleNotification);
  }
  handleNotification = () => {};
}
```

To add an event listener to an element within the shadow boundary, use `template`.

```js
this.template.addEventListener()
```

To add an event listener to an element that a template doesn’t own, call `addEventListener` directly.

```js
this.addEventListener()
```

<br>

### Get a Reference to the Component That Dispatched the Event

use the `Event.target` property.

<br>

### Remove Event Listeners

use the `disconnectedCallback` lifecycle hook to remove events from non-components (like the `window` object, the `document` object, etc.).

<br>

---

<br>
<br>

## Configure Event Propagation

<br>

---

<br>
<br>

## Communicate Across the DOM

<br>

---

<br>
<br>

## Events Best Practices

<br>

# Create Components

## Define a Component

Each component that renders UI must include an HTML file, a JavaScript file, and a metadata configuration file.

They all should share a same file name so the framework can wire them together.

### Naming convention

- Must begin with a lowercase letter
- Must contain only alphanumeric or underscore characters
- Must be unique in the namespace
- Can’t include whitespace
- Can’t end with an underscore
- Can’t contain two consecutive underscores
- Can’t contain a hyphen (dash)

Use `camel case` to name your components. Camel case component folder names map to `kebab-case` in markup.

In markup, to reference a component with the folder name `myComponent`, use `<c-my-component>`.

```html
<-- parent.html -->
<template>
    <c-my-component></c-my-component>
</template>
```

<br>
<br>

### Component Namespaces

Every component is part of a namespace.

To reference your own components:


- Within an HTML template:

```html
// compositionBasics.html
<template>
    <lightning-card title="CompositionBasics">
        <!-- Reference: -->
        <c-contact-tile contact={contact}></c-contact-tile>
    </lightning-card>
</template>
```

- Within a JavaScript class:

```js
// example.js
import { LightningElement } from 'lwc';

import { MyNamedExport } from 'c/commonUtils';
import MyDefaultExport from 'c/commonUtils';

export default class Example extends LightningElement {

}
```

<br>
<br>

### Component HTML File

Every UI component must have an HTML file with the root tag `<template>`.

```html
<!-- myComponent.html -->
<template>
    <!-- Replace comment with component HTML -->
</template>
```

<br>
<br>

### Component JavaScript File

- UI components: JavaScript defines the HTML element.
- Service component (library): JavaScript exports functionality for other components to use.

Everything declared in a module scoped to the module.

```js
import { LightningElement } from 'lwc';
export default class MyComponent extends LightningElement {

}
```

`LightningElement` is a custom wrapper of the standard HTML element.

Pascal Casing is the convention for the class name - the first letter of each word is capitalized.

For instance: For `myComponent.js`, the class name is `MyComponent`.

<br>

#### Service Component (Library)

Create an ES6 module and export the variables or functions that you want to expose and share between other components.

<br>

#### Additional JavaScript Files

Component’s folder can contain other JavaScript files to share code.

```js
// myFunction.js
export default myFunction () { ··· }
```

It can imported as:

```js
// consumerComponent.js
import myFunction from 'c/myFunction';
```

<br>

It can also export named functions or variables.

```js
// mortgage.js
const getTermOptions = () => {
    return [
        { label: '20 years', value: 20 },
        { label: '25 years', value: 25 },
    ];
};

const calculateMonthlyPayment = (principal, years, rate) => {
    // Logic
};

export { getTermOptions, calculateMonthlyPayment };
```

and imported like:

```js
import { getTermOptions, calculateMonthlyPayment } from 'c/mortgage';
```

<br>
<br>

### Component Configuration File

Configuration file defines the metadata values for the component.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>51.0</apiVersion>
  <isExposed>true</isExposed>
  <masterLabel>Best Component Ever</masterLabel>
  <description>This is a demo component.</description>
  <targets>
      <target>lightning__RecordPage</target>
      <target>lightning__AppPage</target>
      <target>lightning__HomePage</target>
  </targets>
  <targetConfigs>
      <targetConfig targets="lightning__RecordPage">
          <property name="prop1" type="String" />
          <objects>
              <object>Account</object>
              <object>Opportunity</object>
              <object>Warehouse__c</object>
          </objects>
      </targetConfig>
      <targetConfig targets="lightning__AppPage, lightning__HomePage">
          <property name="prop2" type="Boolean" />
      </targetConfig>
  </targetConfigs>
</LightningComponentBundle>
```

Read documentation here: [XML Configuration File Elements](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.reference_configuration_tags)

<br>
<br>

### Component Tests

Create a folder called `__tests__` at the top level of the component’s folder. Save the tests inside this folder.

<br>
<br>

### Component CSS File

Use standard CSS syntax to style Lightning web components.

To share CSS style rules between components:

1. create a module that contains only a CSS file and a configuration file.
2. Import the module into the CSS files of Lightning web components.

```css
/* myComponent.css */

/* Example */
@import 'c/cssLibrary';
```

<br>
<br>

### Component SVG Icon

Only one SVG per folder can be created. It must be named `<component>.svg`.

<br>

---

<br>
<br>

## HTML Templates

LWC uses the virtual DOM to render components smartly and efficiently.

<br>

### Data Binding in a Template

We can bind properties in HTML to JavaScript by surrounding then with curly braces: `{property}`.

Note: do NOT use spaces around the property: ` {property} `.

A property should contain a primitive values, except for `for:each` and `iterator` directives.

```html
<!-- hello.html -->
<template>
    Hello, {greeting}!
</template>
```

```js
// hello.js
import { LightningElement } from 'lwc';

export default class Hello extends LightningElement {
    greeting = 'World';
}
```

The `{}` can point to a property inside and object: `{data.name}` or holds an expression:

```html
<!-- helloBinding.html -->
<template>
    <p>Hello, {greeting}!</p>
    <lightning-input label="Name" value={greeting} onchange={handleChange}></lightning-input>
</template>
```

```js
// helloBinding.js
import { LightningElement } from 'lwc';

export default class HelloBinding extends LightningElement {
    greeting = 'World';

    handleChange(event) {
        this.greeting = event.target.value;
    }
}
```

The function `handleChange` has been bind to `onchange` event of `lightning-input` directive.

<br>

#### Compute property value

Use JavaScript getters to compute complex values instead of expressions.

```js
// helloExpressions.js
import { LightningElement } from 'lwc';

export default class HelloExpressions extends LightningElement {
    firstName = '';
    lastName = '';

    get uppercasedFullName() {
        return `${this.firstName} ${this.lastName}`.toUpperCase();
    }
}
```

<br>

### Render DOM Elements Conditionally

The `if:true|false={property}` directive binds data to the template and removes and inserts DOM elements based on whether the data is a truthy or falsy value.

```html
<!-- helloConditionalRendering.html -->
<template>    
    <template if:true={areDetailsVisible}>
        <div>
            These are the details!
        </div>
    </template>
</template>
```

<br>

### Render Lists

Use `for:each` directive or the `iterator` directive to iterate over an array.

#### `for:each`

Use `for:item="currentItem"` to access the current item and `for:index="index"` to access the current index. Also, with `key={uniqueId}` we can assign a key to the elements.

```html
<template>
    <ul class="slds-var-m-around_medium">
        <template for:each={contacts} for:item="contact">
            <li key={contact.Id}>{contact.Name}, {contact.Title}</li>
        </template>
    </ul>
</template>
```

```js
import { LightningElement } from 'lwc';

export default class HelloForEach extends LightningElement {
    contacts = [
        {
            Id: '003171931112854375',
            Name: 'Amy Taylor',
            Title: 'VP of Engineering'
        },
        {
            Id: '003192301009134555',
            Name: 'Michael Jones',
            Title: 'VP of Sales'
        }
    ];
}
```

<br>

#### `iterator`

To apply a special behavior to the first or last item in a list.

```html
<template>
    <ul class="slds-m-around_medium">
        <template iterator:it={contacts}>
            <li key={it.value.Id}>
                <div if:true={it.first} class="list-first"></div>
                {it.value.Name}, {it.value.Title}
                <div if:true={it.last} class="list-last"></div>
            </li>
        </template>
    </ul>
</template>
```

<br>

### Render Multiple Templates

The returned value from the `render()` method must be a template reference.

```js
// miscMultipleTemplates.js

import { LightningElement } from 'lwc';
import templateOne from './templateOne.html';
import templateTwo from './templateTwo.html';

export default class MiscMultipleTemplates extends LightningElement {

    templateOne = true;

    render() {
        return this.templateOne ? templateOne : templateTwo;
    }

    // ...    
}
```

```html
<!-- templateOne.html -->
<template>
    <lightning-card title="Template One">        
    </lightning-card>
</template>
```

```html
<!-- templateTwo.html -->
<template>
    <lightning-card title="Template Two">
    </lightning-card>
</template>
```

Each of the HTML files should reference a CSS file with the same file name (i.e. `templateOne.css`).

<br>

---

<br>
<br>

## CSS

To be completed ...

<br>

---

<br>
<br>

## Reactivity

The framework observes changes to the values of fields and properties.

When it observes a change, it reacts and reevaluates all the expressions used in the template and rerenders the component.

<br>

### Fields

When a component rerenders, the expressions used in the template are reevaluated and the `renderedCallback()` lifecycle hook executes.

To tell the framework to observe changes to the properties of an object or to the elements of an array, decorate the field with `@track`.

```js
@track fullName = { firstName : '', lastName : ''};
this.fullName.firstName = 'John';
```

<br>

### Public Properties

To expose a public property, decorate a field with `@api`.

```js
// todoItem.js
import { LightningElement, api } from 'lwc';
export default class TodoItem extends LightningElement {
    @api itemName = 'New Item';
}
```

```html
<!-- todoItem.html -->
<template>
    <div class="view">
        <label>{itemName}</label>
    </div>
</template>
```

<br>

---

<br>
<br>

## Composition

Composition enables you to build complex components from simpler building-block components.

<br>

### Compose Components

The `lightning` namespace contains many base components, such as `lightning-button`.

```html
<!-- todoApp.html -->
<template>
    <c-todo-wrapper>
        <c-todo-item item-name="Milk"></c-todo-item>
        <c-todo-item item-name="Bread"></c-todo-item>
    </c-todowrapper>
<template>
```

**Owner**: The owner controls all the composed components that it contains. In this example, the owner is the `c-todo-app` component.

Owner can:

- Set public properties
- Call methods on composed components
- Listen for events fire by composed components

**Container**: A container contains other components but also is contained within the owner component. In this example, `c-todo-wrapper` is a container.

Container can:

- Read, but not change, public properties
- Call methods on composed components
- Listen for some, but not necessarily all, events bubbled up by components that it contains.

**Parent and child**: A parent component contains a child component. A parent component can be the owner or a container.

<br>

### Set Properties on Child Components

To communicate down the containment hierarchy, an owner can set a property on a child component.

```js
// todoItem.js
import { LightningElement, api } from 'lwc';
export default class TodoItem extends LightningElement {
    @api itemName;
}
```

```html
<!-- todoApp.html -->
<template>
    <c-todo-item item-name="Milk"></c-todo-item>
    <c-todo-item item-name="Bread"></c-todo-item>
</template>
```

<br>

### Data Flow

Data flows in one direction, from parent to child.

Component with a field with `@api` should set the value only when it initializes it. After that only the owner component should set the value.

Child component can send an `event` to the parent to request a change on the field.

**Recommendation**: use primitive types for properties instead of using objects. Slice complex data structures in a higher-level component and pass the primitive values to the component descendants.

<br>

### Call Methods on Child Components

Public method are decorated with `@api` as well.

```js
// videoPlayer.js
import { LightningElement, api } from 'lwc';

export default class VideoPlayer extends LightningElement {
    @api videoUrl;

    @api
    play() {
        const player = this.template.querySelector('video');
        // the player might not be in the DOM just yet
        if (player) {
            player.play();
        }
    }

    //...
}
```
**Note**: To access elements that the template owns, the code uses the **template** property.

The `c-method-caller` component contains `c-video-player` and has buttons to call the `play()`:

```html
<!-- methodCaller.html -->
<template>
    <div>
        <c-video-player video-url={video}></c-video-player>
        <button onclick={handlePlay}>Play</button>
    </div>
</template>
```

```js
// methodCaller.js
import { LightningElement } from 'lwc';

export default class MethodCaller extends LightningElement {
    video = "https://www.w3schools.com/tags/movie.mp4";

    handlePlay() {
        this.template.querySelector('c-video-player').play();
    }

    //...
}
```

**Note**: The `querySelector()` method returns the first element that matches the selector.
When iterating over an array, add other attribute to the element, like a 'class' or `data-* value`.

<br>

### Pass Markup into Slots

A slot (`<slot></slot>`) is a placeholder for markup that a parent component passes into a component’s body.

<br>

#### Unnamed Slots

For any markup that a parent component passes into the body of child.

```html
<!-- slotDemo.html -->
<template>
    <h1>Add content to slot</h1>
    <div>
        <slot></slot>
    </div>
</template>
```

Parent pushes a paragraph to child:

```html
<!-- slotWrapper.html -->
<template>
    <c-slot-demo>
        <p>content from parent</p>
    </c-slot-demo>
</template>
```

<br>

#### Named Slots

```html
<!-- namedSlots.html -->
<template>
    <p>First Name: <slot name="firstName">Default first name</slot></p>
</template>
```

```html
<!-- slotsWrapper.html -->
<template>
    <c-named-slots>
        <span slot="firstName">Willy</span>
    </c-named-slots>
</template>
```

<br>

#### Access Elements Passed Via Slots

The DOM elements that are passed into the slot aren’t part of the component’s shadow tree. Access them with `this.querySelector()`.

<br>

#### Run Code on `slotchange`

The `slotchange` event fires when a direct child of a node in a `<slot>` element changes.

```html
<!-- container.html -->
<template>
    <slot onslotchange={handleSlotChange}></slot>
</template>
```

Changes within the children of the `<slot>` element don’t trigger a `slotchange` event.

<br>

### Access Elements the Component Owns

To access elements rendered by a component, use the template property.

```js
this.template.querySelector();
this.template.querySelectorAll();
```

- The order of elements is not guaranteed.
- Elements not rendered to the DOM aren’t returned in the querySelector result.
- Don’t use ID selectors with querySelector.

<br>

### Shadow DOM

Encapsulating the *DOM* via *Shadow DOM* gives the ability to share a component and protect the component from being manipulated.

In the example below, `c-todo-item` is enclosed in  `c-todo-app`. The `#shadow-root` defines the boundary between the DOM and the shadow tree.

```html
<c-todo-app>
  #shadow-root
    <div>
        <p>Your To Do List</p>
    </div>
    <c-todo-item>
      #shadow-root
        <div>
            <p>Go to the store</p>
        </div>
    </c-todo-item>
</c-todo-app>
```

**CSS**: CSS styles defined in a parent component don’t leak into a child.

**Events**: if an event bubbles up and crosses the shadow boundary, some property values change to match the scope of the listener.

**Access Elements**: Code can’t use `document` or `document.body` to access the shadow tree of a Lightning web component.

**Access Slots**: DOM elements that are passed to a component via slots aren’t owned by the component. Access them with `this.querySelector()`.

<br>

### Compose Components Using Slots Vs Data

To be completed...

<br>

---

<br>
<br>

## Fields, Properties, and Attributes

<br>

### Property and Attribute Names

Property names in JavaScript are in camel case while HTML attribute names are in kebab case.

- JavaScript: itemName
- HTML: item-name

<br>

### Web API Properties

Lightning web components reflect the properties of many Web APIs.

#### Element

to be completed...

#### EventTarget

to be completed...

<br>

### Use Getters and Setters to Modify Data

If you write a setter for a public property, you must also write a getter. Annotate either the getter or the setter with @api, but not both.

```js
// todoItem.js
import { LightningElement, api } from 'lwc';
export default class TodoItem extends LightningElement {
    uppercaseItemName;

    @api
    get itemName() {
        return this.uppercaseItemName;
    }

    set itemName(value) {
       this.uppercaseItemName = value.toUpperCase();
    }
}
```

<br>

### Reflect JavaScript Properties to HTML Attributes

All HTML attributes are reactive by default. When an attribute’s value changes in the component HTML, the component is rerendered.

```html
/* parent.html */
<template>
    <c-my-component title="Hover Over the Component to See Me"></c-my-component>
</template>
```

```js
// myComponent.js
import { LightningElement, api } from 'lwc';

export default class MyComponent extends LightningElement {
    privateTitle;

    @api
    get title() {
        return this.privateTitle;
    }

    set title(value) {
        this.privateTitle = value.toUpperCase();
        this.setAttribute('title', this.privateTitle);
    }
}
```

`setAttribute()` reflects the property’s value to the HTML attribute and will generated this HTML:

```html
<c-my-component title="HOVER OVER THE COMPONENT TO SEE ME">
    <div>Reflecting Attributes Example</div>
</c-my-component>
```

<br>

---

<br>
<br>

## JavaScript

### Share JavaScript Code

Export a single default function or variable:

```js
// myFunction.js
export default myFunction () { ··· }
```

And imports as:

```js
import myFunction from 'c/myFunction';
```

We can also export named functions or variables:

```js
// mortgage.js
const getTermOptions = () => {
    return [
        { label: '20 years', value: 20 },
        { label: '25 years', value: 25 },
    ];
};

const calculateMonthlyPayment = (principal, years, rate) => {
    // Logic
};

export { getTermOptions, calculateMonthlyPayment };
```

And imports as:

```js
import { getTermOptions, calculateMonthlyPayment } from 'c/mortgage';
```

<br>

### Use Third-Party JavaScript Libraries

To use a third party library:

1. Download the library from the third-party library's site.
2. Upload the library to your Salesforce organization as a static resource.
3. In a JavaScript class that extends `LightningElement`:
   - Import the library by its static resource name:
   ```js
   import myLib from '@salesforce/resourceUrl/myLib';
   ```
   - Import methods from the `platformResourceLoader` module:
   ```js
   import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
   ```
4. Load the library and call its functions in a then() method:
```js
loadScript(this, myLib + '/myLib.js').then(() => {
    let result = myLib.myFunction(2,2);
});
```

Using JavaScript to manipulate the DOM isn’t recommended.

<br>

---

<br>
<br>

## Access Salesforce Resources

Lightning components can access global Salesforce values.

<br>

### Access Static Resources

Import static resources from the @salesforce/resourceUrl scoped module.

```js
import myResource from '@salesforce/resourceUrl/resourceReference';
```

If the static resource is in a managed package, use the managed package namespace:

```js
import myResource from '@salesforce/resourceUrl/namespace__resourceReference';
```

<br>

### Access Content Asset Files

Convert a Salesforce file into a content asset file to use the file in custom apps and Experience Builder templates.

```js
import myContentAsset from '@salesforce/contentAssetUrl/contentAssetReference';
```

If the asset file is in a managed package:

```js
import myContentAsset from '@salesforce/contentAssetUrl/namespace__contentAssetReference';
```

<br>

### Use SVG Resources

Two ways:

1. Add it directly to your component's HTML template.
    ```html
    <template>
        <svg version="1.1" baseProfile="full" width="300" height="200" xmlns="http://www.w3.org/2000/svg">
            <rect width="100%" height="100%" fill="red"></rect>
            <circle cx="150" cy="100" r="80" fill="green"></circle>
            <text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text>
        </svg>
     </template>
   ```
2. Upload the SVG resource as a static resource.
    ```js
    import SVG_LOGO from '@salesforce/resourceUrl/logo';
    ```

<br>

### Access Labels

Custom labels are text values stored in Salesforce that can be translated into any language that Salesforce supports.

```js
import labelName from '@salesforce/label/labelReference';
```

<br>

### Current User ID

To get information about the current user:

```js
import property from '@salesforce/user/property';
```

Example:

```js
import { LightningElement } from 'lwc';
import Id from '@salesforce/user/Id';

export default class MiscGetUserId extends LightningElement {
    userId = Id;
}
```

<br>

### Permissions

Customize a component’s behavior based on the permissions of the context user.

To check whether a user has a permission, import a static reference to the permission and evaluate whether it’s `true` or `undefined`.

```js
import { LightningElement } from 'lwc';
import hasViewSetup from '@salesforce/userPermission/ViewSetup';

export default class App extends LightingElement {
    get isSetupEnabled() {
        return hasViewSetup;
    }

    openSetup(e) {...}
}
```

Import custom permission from:

```js
import hasPermission from '@salesforce/customPermission/PermissionName';
```

<br>

---

<br>
<br>

## Component Lifecycle

### Constructor

Fires when a component instance is created.

Requirements:

- The first statement must be `super()`.
- Don’t use a return statement inside the constructor body, unless it is a simple early-return (`return` or `return this`).
- Don’t use the `document.write()` or `document.open()` methods.
- Don’t inspect the element's attributes and children, because they don’t exist yet.
- Don’t inspect the element’s public properties, because they’re set after the component is created.

#### Don’t Add Attributes to Host Element During Construction

This example is illegal:

```js
import { LightningElement } from 'lwc';
export default class Deprecated extends LightningElement {
    constructor() {
        super();
        this.classList.add('new-class');
    }
}
```

<br>

### `connectedCallback()` and `disconnectedCallback()`

- `connectedCallback()` lifecycle hook fires when a component is inserted into the DOM.
- `disconnectedCallback()` lifecycle hook fires when a component is removed from the DOM.

You can’t access child elements from the callbacks because they don’t exist yet.

Use `connectedCallback()` to:

- Perform initialization tasks, such as fetch data, set up caches, or listen for events
- Subscribe and Unsubscribe from a Message Channel.

<br>

### `renderedCallback()`

To perform logic after a component has finished the rendering phase.

A component is usually rendered many times during the lifespan of an application.

To perform a one-time operation, use a boolean field like `hasRendered` to track whether `renderedCallback()` has been executed.

<br>

### `errorCallback()`

To create an error boundary component that captures errors in all the descendent components in its tree.

You can create an error boundary component and reuse it throughout an app:

```js
// boundary.js
import { LightningElement } from 'lwc';
export default class Boundary extends LightningElement {
    error;
    stack;
    errorCallback(error, stack) {
        this.error = error;
    }
}
```

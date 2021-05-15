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
<br>

---

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
<br>

<br>
<br>

<br>
<br>
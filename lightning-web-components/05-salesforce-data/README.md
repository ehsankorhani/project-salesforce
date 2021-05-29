# Working with Salesforce Data

There are several ways for Lightning web components to work with data.

## Data Guidelines

- easiest way: base Lightning components
- more flexible: Lightning Data Service wire adapter
- even more flexible: Apex

<br>

### Use Base Lightning Components Built on Lightning Data Service

- `lightning-record-form`
    
    Easiest way to display a form to create, edit, or view a record.

    It loads all fields in the object's compact or full layout, or only the fields that you specify.

- `lightning-record-edit-form`

    to add or update a record.
    
    prepopulate field values using the `lightning-input-field` component.

- `lightning-record-view-form`

    to view a record.

<br>

### Use Lightning Data Service Wire Adapters and Functions

Use `@wire` to specify the `getRecord` Lightning Data Service wire adapter.

<br>

### Use Apex

Unlike Lightning Data Service data, Apex data is not managed; you must refresh the data with `refreshApex()` or `getRecordNotifyChange()` to update the cache.

in *Lightning Data Service* changes to a record are reflected in all the technologies built on it.

<br>

---

<br>
<br>

## Lightning Data Service

Records loaded in Lightning Data Service are cached and shared across components.

- Components— `lightning-record-edit-form`, `lightning-record-form`, and `lightning-record-view-form`
- Wire adapters and functions in the `lightning/ui*Api` modules

<br>

---

<br>
<br>

## Using Base Components


<br>

---

<br>
<br>

## Use the Wire Service

<br>

---

<br>
<br>

## Call Apex Methods

### Import Apex Methods

Import syntax in JavaScript:

```js
import apexMethodName from '@salesforce/apex/Namespace.Classname.apexMethodName';
```

<br>

### Expose Apex Methods to Lightning Web Components

Method must be:

- `static`
- Either `global` or `public`
- Annotated with `@AuraEnabled`

```java
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Picture__c != null
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }
}
```

**Note**: Don't overload `@AuraEnabled` Apex methods.

<br>

### Wire Apex Methods to Lightning Web Components

`@wire` us a reactive service to read Salesforce data.

To import an Apex method and wire it to a component:

```js
import apexMethodName from '@salesforce/apex/Namespace.Classname.apexMethodName';

export default class ComponentName extends LightningElement {
    @wire(apexMethodName, { apexMethodParams })
    propertyOrFunction;

}
```

- `apexMethodParams` is an object with properties that match the parameters of the apexMethod.
- `propertyOrFunction` is a private property or function that receives the stream of data from the wire service.

To pass a parameter preface it with `$` to indicate that it’s dynamic and reactive.

```js
import { LightningElement, wire } from 'lwc';
import findContacts from '@salesforce/apex/ContactController.findContacts';

const DELAY = 300;

export default class ApexWireMethodWithParams extends LightningElement {
    searchKey = '';

    @wire(findContacts, { searchKey: '$searchKey' })
    contacts;

    handleKeyChange(event) {
        // Debouncing this method: Do not update the reactive property as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }
}
```

<br>

And to send a complex object parameter:

```js
// apexWireMethodWithComplexParams.js
import { LightningElement, wire } from 'lwc';
import checkApexTypes from '@salesforce/apex/ApexTypesController.checkApexTypes';

export default class ApexWireMethodWithComplexParams extends LightningElement {
    parameterObject = {
        someString: this.stringValue,
        someInteger: this.numberValue,
        someList: []
    };

    @wire(checkApexTypes, { wrapper: '$parameterObject' })
    apexResponse;

    handleStringChange(event) {
        this.parameterObject = {
            ...this.parameterObject,
            someString: (this.stringValue = event.target.value)
        };
    }

    //...
}
```

To get the returned value from Apex method:

```js
// apexWireMethodToFunction.js
import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';

export default class ApexWireMethodToFunction extends LightningElement {
    contacts;
    error;

    @wire(getContactList)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }
}
```

<br>

### Call Apex Methods Imperatively

`@wire(apexMethod)` provides a stream of values and supports dynamic parameters.

This code provides a one-time resolution given a set of parameters:

```js
// apexImperativeMethod.js
import { LightningElement, track } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';

export default class ApexImperativeMethod extends LightningElement {
    @track contacts;
    @track error;

    handleLoad() {
        getContactList()
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
}
```

<br>

### Client-Side Caching of Apex Method Results

Annotating the Apex method with `@AuraEnabled(cacheable=true)`, caches the method results on the client.

To set `cacheable=true`, a method must only get data, it can’t mutate data.

<br>

#### Refresh the Cache When Calling a Method Imperatively

Call `getRecordNotifyChange(recordIds)` to update the Lightning Data Service (LDS) cache.

```js
import { LightningElement, wire } from 'lwc';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import apexUpdateRecord from '@salesforce/apex/Controller.apexUpdateRecord';
 
export default class Example extends LightningElement {
    @api recordId;
 
    // Wire a record.
    @wire(getRecord, { recordId: '$recordId', fields: ... })
    record;
 
    async handler() {
      // Update the record via Apex.
      await apexUpdateRecord(this.recordId);
      // Notify LDS that you've changed the record outside its mechanisms.
      getRecordNotifyChange([{recordId: this.recordId}]);
    }
}
```

<br>

#### Refresh the Cache When Using @wire

Call `refreshApex()`.

```js
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getOpptyOverAmount from '@salesforce/apex/OpptyController.getOpptyOverAmount;

@wire(getOpptyOverAmount, { amount: '$amount' })
opptiesOverAmount;

// Update the record using updateRecord(recordInput) 
// Refresh Apex data that the wire service provisioned
handler() { 
  updateRecord(recordInput).then(() => {
    refreshApex(this.opptiesOverAmount);
  });
}
```

<br>

### Import Objects and Fields from `@salesforce/schema`

Call `getSObjectValue()` to get a field value from the object:

```js
import { LightningElement, wire } from 'lwc';
import { getSObjectValue } from '@salesforce/apex';
import getSingleContact from '@salesforce/apex/ContactController.getSingleContact';

import NAME_FIELD from '@salesforce/schema/Contact.Name';

export default class ApexStaticSchema extends LightningElement {
    @wire(getSingleContact) contact;

    get name() {
        return this.contact.data ? getSObjectValue(this.contact.data, NAME_FIELD) : '';
    }
}
```

<br>

### Continuations

Use the Continuation class in Apex to make a long-running request to an external Web service.


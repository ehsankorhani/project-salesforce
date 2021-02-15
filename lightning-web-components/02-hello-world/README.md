# Hello World in a Scratch Org

### Create a Lightning Web Component

We are going to create a component at this path: `force-app/main/default/lwc`.

You can do this a multiple way:

1. In VS Code press `ctrl+shift+p` and select: `SFDX: Create Lightning Web Component`<br>
Select the directory and choose `helloWorld` for the file name.
2. Right click on the `lwc` folder and select: `SFDX: Create Lightning Web Component`
3. Use CLI directly and type the following:

```bash
cd force-app/main/default/lwc
sfdx force:lightning:component:create --type lwc -n helloWorld -d force-app/main/default/lwc
```

<br>

### Create the Hello World Component

In `helloWorld.js` add:

```js
import { LightningElement, api } from 'lwc';

export default class HelloWorld extends LightningElement {
    @api name;
}
```

The `@api` decorator will make the `name` property public.

Now, add the following to the `helloWorl.html` file:

```html
<template>
    <lightning-card title="HelloWorld" icon-name="custom:custom14">
        <div class="slds-card__body slds-card__body_inner">
            Hello, {name}!
        </div>
    </lightning-card>
</template>
```

The `{}` syntax binds the name property in the HTML template to the `name` property in the JavaScript class.

<br>

### Configure the Component for Lightning App Builder

To be able to add the component to a Lightning page, we must add specific configurations.

Add or edit the following to the `helloWorld.js-meta.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata" fqn="anotherComponent">
    <apiVersion>50.0</apiVersion>
    <isExposed>true</isExposed>
    <masterLabel>Hello World</masterLabel>
    <description>Add a classic greeting to any page.</description>
    <targets>
      <target>lightning__AppPage</target>
    </targets>
    <targetConfigs>
      <targetConfig targets="lightning__AppPage">
          <property name="name" type="String" label="Name" placeholder="World" description="Enter the name of the person to greet."/>
      </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

- Set `<isExposed>` to `true` so the component can be used in Lightning App Builder.
- The `<target>` lets us add the component to an app page.
- `<targetConfigs>` section is to set the component’s name property.

<br>

### Push Source to the Scratch Org

Push the component with either by VS Code extension `SFDX: Open Default Scratch Org` or through the CLI:

```bash
$ sfdx force:source:push
```

<br>

### Add the Component to a Lightning Page

1. In the scratch org, in Setup, enter bui and click Lightning App Builder.
2. To create a Lightning page, click New.
3. Select App Page and click Next.
4. Enter the label Hello World.
5. Select Three Regions and click Finish.
6. Select the component and enter a Name.
7. Drag more Hello World components to the page, and set a different name for each component.
8. When your page is complete, click Save and Activate.
9. On the Activation page, select an icon, then click Lightning Experience, and add the page to the Lightning Bolt app. Click Save.
10. To exit Lightning App Builder, click Back.
11. From the App Picker, click Bolt Solutions.
12. Click the Hello World tab to see your page and all its greetings.
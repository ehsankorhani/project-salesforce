# 2nd Generation Packaging

## What is a Package?

Package is a container that you fill with metadata and components such as Apps, Tabs, Objects, Layouts, Workflows, Approval Process Flows, visualforce, apex, lightning components, profiles, permission sets, etc.

A package can be used for distribution or deployment.

<br>

## Package types

There are three Salesforce package types

- Unmanaged
- Managed
- Unlocked

**Unmanaged packages**: are typically used to distribute open-source projects or application templates to provide developers with the basic building blocks for an application.

Once the components are installed from an unmanaged package, the components can only be edited in the organization they are installed in.

**Managed packages**: are typically used by Salesforce partners to distribute and sell applications to customers.

Managed packages are fully upgradeable but certain destructive changes, like removing objects or fields, can not be performed.

**Unlocked packages**: help you add, edit, and remove metadata in your org in a trackable way. It is a new type of packaging solution that is being offered as part of Salesforce DX.

Unlocked packages follow a source-driven development model. They can be installed into multiple Orgs, and upgrade the Salesforce apps easier and faster.

<br>

### A tabular comparison of different package types:

<br>

| Unmanaged Package | Managed Package | Unlocked Package |
| :---------------- | :-------------- | :--------------- |
| Not upgradable | Upgradable and has namespace | Upgradable and can have namespace |
| Metadata elements are not IP Protected | Metadata elements are IP Protected | Metadata elements are not locked and can be changed by system admins |
| Can be created in Salesforce UI | Can be created in salesforce UI and distributed via AppExchange | Requires Salesforce CLI to generate them |
| Automatically pull dependency | Components are locked and one cannot modify them directly in production or sandbox | Allows you to build your applications in a modular way |
| | Allows for creation of extension packages | Easier to manage when codebase is modularized |

<br>

---

<br>
<br>

## Enable Packaging

### 1. Enable DevHub

Log in as System Administrator to your Developer Edition, trial, or production org (for customers), or your business org (for ISVs).

1. Setup > Dev Hub
2. Click "Enable Dev Hub"

### 2. Enable Unlocked Packages and Second-Generation Managed Packages

In the org where you’ve enabled Dev Hub:

1. Setup > Dev Hub
2. Select "Enable Unlocked Packages and Second-Generation Managed Packages"

<br>

---

<br>
<br>

## Create a Package

Your `sfdx-project.json` could look like the following before starting the package creation:

```js
{
    "packageDirectories": [
        {
            "path": "force-app",
            "default": true
        }
    ],
    "namespace": "",
    "sfdcLoginUrl": "https://login.salesforce.com",
    "sourceApiVersion": "50.0"
}
```

Specify the package namespace in the `sfdx-project.json` file if required.

**Note**: In order to set the `namespace` it should be owned by the dev hub.

<br>

Unlocked package:

```bash
$ sfdx force:package:create --name "My App" --packagetype Unlocked --path "force-app" --targetdevhubusername my-hub --errornotificationusername me@devhub.org
```

Managed package:

```bash
$ sfdx force:package:create --name "My App" --packagetype Managed
--path "force-app" --targetdevhubusername my-hub --errornotificationusername me@devhub.org
```

<br>

### Update the package

Name or Description or the User of an existing package can change with:

<br>

Unlocked package:

```bash
$ sfdx force:package:update --package "My App" --name "My App New" --description "New Description" --errornotificationusername me2@devhub.org
```

Managed package:

```bash
$ sfdx force:package:update --package "My App" --name "My App New" --description "New Description" --errornotificationusername me2@devhub.org
```

<br>

After the command is run successfully a message like the following will appear:

```bash
sfdx-project.json has been updated.
Successfully created a package. 0Ho5g000000GmrGCAS
=== Ids
NAME        VALUE
──────────  ──────────────────
Package Id  0Ho5g000000GmrGCAS
```

And the `sfdx-project.json` will look like:

```js
{
    "packageDirectories": [
        {
            "path": "force-app",
            "default": true,
            "package": "My App",
            "versionName": "ver 0.1",
            "versionNumber": "0.1.0.NEXT"
        }
    ],
    "namespace": "",
    "sfdcLoginUrl": "https://login.salesforce.com",
    "sourceApiVersion": "50.0",
    "packageAliases": {
        "My App": "0Ho5g000000GmrGCAS"
    }
}
```

<br>

---

<br>
<br>

### References

- [Second-Generation Managed Packages](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_dev2gp.htm)
- [SalesforceWay - Salesforce unlocked packages | 2nd gen packaging | jump-start for beginners](https://youtu.be/T8nevlPxHsc)
- [FAQ on Unlocked Packages](https://sfdc-db-gmail.github.io/unlocked-packages/faq-unlocked-pkgs.html#unlocked-pkgs)
- [Unlocked Packages | Modular Application Development Using Unlocked Packages | 2GP](http://amitsalesforce.blogspot.com/2019/10/unlocked-packages-modular-application-development.html)


<!--
https://salesforceway.com/podcast/unlocked-packages/
https://developer.salesforce.com/docs/metadata-coverage/47

https://developer.salesforce.com/blogs/2018/06/working-with-modular-development-and-unlocked-packages-part-1.html
    -> Do I have to use packages for everything?
-->
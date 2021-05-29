# Package.xml

Tells the system things like which specific metadata components to retrieve, deploy, or update.

<br>

## Structure

| Name | Description |
| :--- | :---------- |
| `<types>` | Lists the metadata components of a certain type.<br> contains one or more `<members>` tags and one `<name>` tag |
| `<members>` | Name of a component |
| `<name>` | Type of the component |
| `<version>` | Metadata API version number.<br> When deploying, all files must conform to the same version |

## Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>Accounts</members>
        <name>ApexClass</name>
    </types>
    <types>
        <members>*</members>
        <name>Profile</name>
    </types>
    <types>
        <members>AccountTrigger</members>
        <name>ApexTrigger</name>
    </types>
    <types>
        <members>namespace__MyObject1__c</members>
        <members>namespace__MyObject1__c</members>
        <name>CustomObject</name>
    </types>
    <types>
        <members>*</members>
        <name>CustomField</name>
    </types>
    <types>
        <members>*</members>
        <name>CustomMetadata</name>
    </types>
    <types>
        <members>*</members>
        <name>Layout</name>
    </types>
    <types>
        <members>*</members>
        <name>CompactLayout</name>
    </types>
    <types>
       <members>My_Report/My_Report_Details</members>
       <name>Report</name>
    </types>
    <types>
        <members>Account</members>
        <name>Settings</name>
    </types>
    <types>
        <members>*</members>
        <name>RecordType</name>
    </types>
    <types>
        <members>Salesforce1</members>
        <name>AppMenu</name>
    </types>
    <version>45.0</version>
</Package>
```

<br>

## Build a Package.xml Manifest

Create your `package.xml` file based on what metadata you want to retrieve and deploy.

Example:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>Accounts</members>
        <name>ApexClass</name>
    </types>
    <types>
        <members>AccountTrigger</members>
        <name>ApexTrigger</name>
    </types>
    <types>
        <members>namespace__MyObject1__c</members>
        <members>namespace__MyObject1__c</members>
        <name>CustomObject</name>
    </types>
    <version>45.0</version>
</Package>
```

<br>

## Retrieve and Deploy MetaData from and to existing Orgs

Using your `package.xml` file, run the following command:

```bash
$ sfdx force:mdapi:retrieve -u <SourceOrgAlias> -k ./package.xml
```

Alternatively, yo retrieve things cleaner and in one place we can download them in one zipped package:

```bash
$ sfdx force:mdapi:retrieve -r ./mdapipkg -u <SourceOrgAlias> -k ./package.xml
```

Unzip the file downloaded to `./mdapipkg` and delete the zip file.

Execute this script to deploy to destination org:

```bash
$ sfdx force:mdapi:deploy -u <DestOrgAlias> -d ./mdapipkg --verbose
```

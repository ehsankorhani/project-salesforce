# Create an Scratch Org from Source

### Create a new Git branch

Before beginning to work on a new project you may want to create a new `feature` branch off you `develop` or `main` branch.

```bash
$ git checkout -b feature/myNewTask
```

### Create a new Scratch Org

The source of the project created should have a one or more `config` files. For example, `project-scratch-def.json` or `preview-scratch-def.json`.

Click `ctrl+shift+p` (or `F1`) to open the command palette and select:

```bash
SFDX: Create a Default Scratch Org...
```

And then select the `config` file, enter a Name for the scratch org, and number of days until it expires.

Alternatively, in you terminal type:

```bash
sfdx force:org:create -f project-scratch-def.json -a MyScratchOrgAlias --durationdays 30
```

Wait for the operation to finish. You should be able to get the `Org Id` and a `username` (i.e. test-b4agup43oxmu@example.com).

<br>

### Generate Password

You can open the scratch org from VS Code (as long as the authentication is valid and it's not expired). However, it is possible to generate a password (for instance if it's required for another person to view the scratch org).

The command to generate a password is:

```bash
sfdx force:user:password:generate -u MyScratchOrgAlias
```
<br>

### Push Metadata

Now, you're ready to push metadata to the scratch org.

Use command palette:

```bash
SFDX: Push Source to Default Scratch Org
```

Or enter this command in terminal:

```bash
$ sfdx force:source:push
```

To override previous changes you can enter:

```bash
$ sfdx force:source:push -f
```

<br>

### Assign Permission Set

You might already have Permission Sets in the source and want to assign it to the scratch org admin.

Enter:

```bash
$ sfdx force:user:permset:assign --permsetname My_Permission_Set_Name
```

<br>

### Import (or export) data : with Texei Plugin

In addition, you can import existing data to the scratch org. These data are in `json` format and you would normally place them in `./data` directory.

You need to have the **Texei** plugin installed in order to complete this step. Read about the installation from: https://github.com/texei/texei-sfdx-plugin#install-plugin.

Enter this command to *import* data from source to the scratch org:

```bash
sfdx texei:data:import --inputdir ./data/myDataDir
```

On the opposite side, this command will allow you to export data from scratch org to the source directory:

```bash
$ sfdx texei:data:export --objects namespace__My_Obj1__c,namespace__MY_Obj2__c --outputdir ./data/myExportedDataDir
```

<br>

### Create data : with Script

Alternatively, you might want to run an script to create some sample data in the org. You can have prepared a simple script to create required objects, add data and `upsert` them.

Then you can run the script on the scratch org with:

```bash
$ sfdx force:apex:execute -f ./scripts/setupMyObj.apex
```

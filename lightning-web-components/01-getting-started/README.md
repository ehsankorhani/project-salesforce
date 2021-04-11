# Getting Started

## Setup

<br>

---

## Develop in a Scratch Org

<br>

---

## Deploy to a Non-Scratch Org

When you deploy source code to an org, the entire path that you specify is deployed.

```bash
$ sfdx force:source:deploy -p <pathToDeploy> -u <orgUserName>
```

For instance, to deploy the root directory we would write something like:

```bash
sfdx force:source:deploy -p force-app -u example@force.com
```

We can also get the source code from an org by:

```bash
sfdx force:source:retrieve -p <pathToRetrieve> -u <orgUserName>
```

<br>

---

## Deploy locally

<br>

---

## Mobile Development Preview
# Source Control

Just like any other source driven application, a Salesforce DX project can be added to a source control system - which in most cases will be a Git repo.

<br>

### Initiate a Git repo

CD to DX project folder and:
```
$ git init
```

<br>

### Add sensitive or unwanted stuff to `.gitignore`

Specifically we do not want to publicly share our Org information. Therefore, we should definitely ignore `.sfdx` folder.

When creating a DX project a .gitignore file will be created for you but you can edit that to your liking and preference.

<br>

### Create an online shared repo

Create a new repository in your preferred Git repo. This can be *GitHub*, *BitBucket*, *GitLab*, etc.

<br>

### Add Remote to your local Git

```
$ git remote add origin https://github.com/user/repo.git
```

<br>

### Push source to repo

Stage all the source code:
```
$ git stage .
```

Commit:
```
$ git commit -m "init commit"
```

And push your source:
```
$ git push -u origin master
```

Note that the `-u origin master` part is only needed for the first time we push source to the repo.


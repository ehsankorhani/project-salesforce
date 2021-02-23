# REST Web Services

### `@RestResource`

This annotation exposes an Apex class as a REST resource.

```java
@RestResource(urlMapping='/MyRestContextExample/*')
global with sharing class MyRestContextExample {
    //...
}
```

- Apex class must be defined as global.
- The URL mapping is relative to `https://instance.salesforce.com/services/apexrest/`.
- A wildcard character (`*`) may be used (after `/`).
- The URL mapping is case-sensitive.

In addition, we would annotate methods to expose them through REST.

```java
@RestResource(urlMapping='/Account/*')
global with sharing class MyRestResource {
 
    @HttpDelete
    global static void doDelete() {
        //...
    }
  
    @HttpGet
    global static Account doGet() {
        //...
        return result;
    }
  
    @HttpPost
    global static String doPost(String name,
        //...
        return account.Id;
    }
}
```

Other annotations are:

- `@HttpGet`: this `global static` method is called when an `HTTP GET` (or `HEAD`) request is sent, and returns the specified resource.
- `@HttpDelete`:
- `@HttpPatch`:
- `@HttpPost`:
- `@HttpPut`:
- `@ReadOnly`: less restrictive queries by increasing the limit of the number of returned rows for a request to 100,000.


<br>

### REST Context

The `System.RestContext` class allows access to the `RestRequest` and `RestResponse` objects.

```java
@RestResource(urlMapping='/MyRestContextExample/*')
global with sharing class MyRestContextExample {
 
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];
        return result;
    }
  
}
```

<br>

## Connect to Salesforce REST API

To connect to a resource which has been setup as: `@RestResource(urlMapping='/Account/*')`

We would make a `GET` request to this URL:<br>
`https://instance.salesforce.com/services/apexrest/Account/accountId`

The authorization header should be as: `-H "Authorization: Bearer sessionId"`

The response is gong to be a json like:

```json
{
  "attributes" : 
    {
      "type" : "Account",
      "url" : "/services/data/v22.0/sobjects/Account/accountId"
    },
  "Id" : "accountId",
  "Name" : "Acme"
 
}
```

# HTTP Callouts

We use `HTTP` classes to integrate to REST-based services.

### HTTP Classes

- `Http`: is used to initiate an HTTP request and response.
- `HttpRequest`: 
  - to create HTTP requests such as `GET`, `POST`, `PATCH`, `PUT`, `DELETE`, `TRACE`, `CONNECT`, `HEAD`, and `OPTIONS`
  - Add `header`
  - Set connection timeouts
  - Redirects if needed
  - Set content of the message body
- `HttpResponse`
  - Read HTTP status code
  - Read response headers
  - Read content of the response body

Below is an example of a callout setup:

```java
public String getResponse(String url) {
    Http h = new Http();
    
    /* define the request */
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('GET');

    Blob headerValue = Blob.valueOf('username' + ':' + 'password');
    String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
    req.setHeader('Authorization', authorizationHeader);
    
    req.setTimeout(120000);

    /* receive the response */
    HttpResponse res = h.send(req);
    Integer statusCode = res.getStatusCode();
    String[] headers = res.getHeaderKeys();

    return res.getBody();
}
```

The code above runs *synchronously*. We can make it *asynchronous* by using `@future ` annotation.

In order to be able to call an external server we need to add it to **Remote Site Settings**.

`JSON` classes can parse JSON request or response bodies and `XML` classes will be used for bodies in XML format.


<br>

### Testing HTTP Callouts
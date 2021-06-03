# Varnish cache POST and GET requests

## Quick start

```sh
docker-compose up --build
```

and make some queries to http://localhost:8080

The `date` service is configured to print a log line on each request and displays the current date.
If no log is showing and if the returned date in the body do not change, this will say that the request is cached.

## Testing with `curl`

Things to watch:

- the value of the `X-Cache` header (added manually in the varnish configuration file)
- the date in the body

### Cache MISS

```sh
> curl -X POST -vvv http://localhost:8080

*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080 (#0)
> POST / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< X-Powered-By: Express
< Content-Type: text/html; charset=utf-8
< Content-Length: 94
< ETag: W/"5e-sdqB6gjzQ0iTQNWDOTrhCdqeSMg"
< Date: Thu, 03 Jun 2021 14:50:04 GMT
< X-Varnish: 2
< Age: 0
< Via: 1.1 varnish (Varnish/6.4)
< X-Cache: MISS
< Accept-Ranges: bytes
< Connection: keep-alive
<
POST request ; date = Thu Jun 03 2021 14:50:04 GMT+0000 (Coordinated Universal Time)

BODY:
* Connection #0 to host localhost left intact
{}
```

### Cache HIT

```sh
> curl -X POST -vvv http://localhost:8080

*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080 (#0)
> POST / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< X-Powered-By: Express
< Content-Type: text/html; charset=utf-8
< Content-Length: 94
< ETag: W/"5e-sdqB6gjzQ0iTQNWDOTrhCdqeSMg"
< Date: Thu, 03 Jun 2021 14:50:04 GMT
< X-Varnish: 5 3
< Age: 40
< Via: 1.1 varnish (Varnish/6.4)
< X-Cache: HIT
< Accept-Ranges: bytes
< Connection: keep-alive
<
POST request ; date = Thu Jun 03 2021 14:50:04 GMT+0000 (Coordinated Universal Time)

BODY:
* Connection #0 to host localhost left intact
{}
```

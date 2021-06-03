vcl 4.1;

import std;
import bodyaccess;

# this is the backend that should be cached
backend default {
  .host = "date";
  .port = "3000";
}

# remove cookies from response
sub vcl_backend_response {
  if (beresp.http.Set-Cookie) {
    unset beresp.http.Set-Cookie;
    unset beresp.http.Cache-Control;
    # cache for 1 hr
    set beresp.ttl = 3600s;
  }
}

# remove incoming cookies and allow caching POST requests
sub vcl_recv {
  unset req.http.X-Body-Len;
  unset req.http.cookie;

  if (req.method == "POST") {
    std.cache_req_body(2048KB);
    set req.http.X-Body-Len = bodyaccess.len_req_body();
    return (hash);
  }
}

# https://docs.varnish-software.com/tutorials/caching-post-requests/#step-3-change-the-hashing-function
sub vcl_hash {
  # to cache POST and PUT requests
  if (req.http.X-Body-Len) {
    bodyaccess.hash_req_body();
  } else {
    hash_data("");
  }
}

# https://docs.varnish-software.com/tutorials/caching-post-requests/#step-4-make-sure-the-backend-gets-a-post-request
sub vcl_backend_fetch {
  if (bereq.http.X-Body-Len) {
    set bereq.method = "POST";
  }
}

# add a header to see if it was a cache miss or a cache hit
sub vcl_deliver {
  # https://happyculture.coop/blog/varnish-4-comment-savoir-si-votre-page-vient-du-cache
  if (resp.http.X-Varnish ~ "[0-9]+ +[0-9]+") {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }
}

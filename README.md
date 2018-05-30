# html_analyzer_preview

## API
### Request

```sh
curl -X "POST" "https://kolibri-analyzer.herokuapp.com/proxy/modify" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "data": {
    "url": "http://www.hrtoday.ch/de/article/portraet-renato-ferrara-hr-today"
  }
}'

```

By default the analyzer will try to honour the time to live of the result using the `Cache-Control` of the remote server. If cache is not configured on the server analyzer will cache it for 7 days.

User can override this setting putting `lifetime` parameter in the request.
`lifetime` is with highest priority, so use it wisely. 

To specify custom lifetime of the cache:

```sh
curl -X "POST" "https://kolibri-analyzer.herokuapp.com/proxy/modify" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "data": {
    "url": "http://www.hrtoday.ch/de/article/portraet-renato-ferrara-hr-today",
    "lifetime": "604800000"
  }
}'
```

Where `lifetime` should be in milliseconds.

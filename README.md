# html_analyzer_preview

## API

### GET

`https://kolibri-analyzer.herokuapp.com/`

Get embed variant of a web page with stripped out navigation, header and footer elements.
The response will be with omitted `X-Frame-Options` header in order to be embeddable in
iframe for example to be presented.

```
curl "https://kolibri-analyzer.herokuapp.com/?url=https://mobil.mopo.de/hamburg/haeuser-und-wohnungen-das-kosten-immobilien-in-hamburg-wirklich--30684850" \
     -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1' \
     -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8'
```

### POST

`https://kolibri-analyzer.herokuapp.com/`

Get a modified version of a web page with stripped out `navigation`, `header` and `footer` elements.

```
curl -X "POST" "https://kolibri-analyzer.herokuapp.com/" \
     -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "data": {
    "url": "https://mobil.mopo.de/hamburg/haeuser-und-wohnungen-das-kosten-immobilien-in-hamburg-wirklich--30684850",
    "lifetime": "1000"
  }
}'
```

Where as `data` you can pass:

- `url` for processing **(mandatory)**
- `lifetime` in milliseconds of the cache for this result **(optional)**

#### Lifetime

By default the analyzer will try to honor the time to live of the result using the `Cache-Control` of the remote server. If cache is not configured on the server analyzer will cache it for 7 days.

User can override this setting putting `lifetime` parameter in the request.
`lifetime` is with highest priority, so use it wisely.

#### User Agent

User agent is forwarded by the request. This means if you request from a phone the proxy will process the webpage as a phone
and otherwise if you request from a desktop, the proxy will behalf as desktop.


### DELETE

`https://kolibri-analyzer.herokuapp.com/`

This will clear the cache for all results of processed web pages.

#!/usr/bin/bash

url_index='https://create.microsoft.com/en-us/search?filters=excel'

curl "${url_index}"


curl 'https://create.microsoft.com/api/graphql' \
  -H 'accept: */*' \
  -H 'content-type: application/json' \
  -H 'origin: https://create.microsoft.com' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' \
  --data '@request.ql' |
  python -m json.tool > test.json

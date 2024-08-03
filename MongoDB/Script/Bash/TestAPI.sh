#!/usr/bin/bash

data=$(
echo '{
    "collection": "__COLLECTION_NAME__",
    "database":   "__DATABASE_NAME__",
    "dataSource": "__CLUSTER__",
    "projection": {"_id": 1}
}' |
  jq --arg source  "${CLUSTER}"         '.dataSource = $source'  |
  jq --arg collect 'data'               '.collection = $collect' |
  jq --arg db      'sample_weatherdata' '.database   = $db'
)

URL_API="${ENDPOINT%/}/action/findOne"

curl --location --request POST "${URL_API}" \
  --header 'Content-Type: application/json' \
  --header 'Access-Control-Request-Headers: *' \
  --header "api-key: ${API_KEY}" \
  --data-raw "${data}"


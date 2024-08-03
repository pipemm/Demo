#!/usr/bin/bash

URL_API="${ENDPOINT%/}/action/findOne"
## https://www.mongodb.com/docs/atlas/app-services/data-api/openapi/#operation/aggregate
## https://www.mongodb.com/docs/atlas/app-services/data-api/examples/

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

curl --location --request POST "${URL_API}" \
  --header 'Content-Type: application/json' \
  --header 'Access-Control-Request-Headers: *' \
  --header "api-key: ${API_KEY}" \
  --data-raw "${data}" |
  jq

URL_API="${ENDPOINT%/}/action/aggregate"
## https://www.mongodb.com/docs/atlas/app-services/data-api/openapi/#operation/aggregate
## https://www.mongodb.com/docs/atlas/app-services/data-api/examples/

FILE_DATA='Request/json/data-aggregate.json'
cat "${FILE_DATA}" |
  jq --arg source  "${CLUSTER}"         '.dataSource = $source'  |
  jq --arg db      'sample_weatherdata' '.database   = $db'      |
  jq --arg collect 'data'               '.collection = $collect'

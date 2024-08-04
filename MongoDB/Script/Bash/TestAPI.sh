#!/usr/bin/bash

URL_API="${ENDPOINT%/}/action/aggregate"
## https://www.mongodb.com/docs/atlas/app-services/data-api/openapi/#operation/aggregate
## https://www.mongodb.com/docs/atlas/app-services/data-api/examples/

file_data='Request/json/data-aggregate.json'
data=$(
  cat "${file_data}" |
  jq --arg source  "${CLUSTER}"         '.dataSource = $source'  |
  jq --arg db      'sample_weatherdata' '.database   = $db'      |
  jq --arg collect 'data'               '.collection = $collect'
)

filecatalog='Data-Catalog.json'
cat "${filecatalog}" |
  jq '.databases | [.[] | {database:.name, collections}]' |
  jq '[.[] | .database as $database | collections ]'

curl --location --request POST "${URL_API}" \
  --header 'Content-Type: application/json' \
  --header 'Access-Control-Request-Headers: *' \
  --header "api-key: ${API_KEY}" \
  --data-raw "${data}" |
  jq
#!/usr/bin/bash

URL_API="${ENDPOINT%/}/action/aggregate"
## https://www.mongodb.com/docs/atlas/app-services/data-api/openapi/#operation/aggregate
## https://www.mongodb.com/docs/atlas/app-services/data-api/examples/

file_data='Request/json/data-aggregate.json'
datatemplate=$(
  cat "${file_data}" |
  jq --arg source  "${CLUSTER}"         '.dataSource = $source'  |
  jq --arg db      'sample_weatherdata' '.database   = $db'      |
  jq --arg collect 'data'               '.collection = $collect'
)

filecatalog='Data-Catalog.json'
cat "${filecatalog}" |
  jq '.databases | [.[] | {database:.name, collections}]' |
  jq '[.[] | .database as $database | .collections [] | {database: $database, collection: .} ]' |
  jq --compact-output '.[]' |
  while read -r req
  do
    db=$(echo "${req}" | jq --raw-output '.database')
    collection=$(echo "${req}" | jq --raw-output '.collection')
    data=$(
      echo "${datatemplate}" |
      jq --arg db         "${db}"         '.database   = $db'         |
      jq --arg collection "${collection}" '.collection = $collection'
    )
    echo "database   : ${db}"
    echo "collection : ${collection}"
    curl --location --request POST "${URL_API}" \
      --header 'Content-Type: application/json' \
      --header 'Access-Control-Request-Headers: *' \
      --header "api-key: ${API_KEY}" \
      --data-raw "${data}" |
      jq
  done


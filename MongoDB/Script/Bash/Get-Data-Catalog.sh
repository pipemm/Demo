#!/usr/bin/bash

URL_API="${ENDPOINT%/}/action/listDatabasesCollections"

curl \
  --header 'Content-Type: application/json' \
  --header "api-key: ${API_KEY}" \
  "${URL_API}" |
  jq

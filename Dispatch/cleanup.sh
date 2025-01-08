#!/usr/bin/bash

curl --location \
  --header 'Accept: application/vnd.github+json' \
  --header "Authorization: Bearer ${GITHUB_TOKEN}" \
  --header 'X-GitHub-Api-Version: 2022-11-28' \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}/artifacts" |
  jq '[.artifacts[] | [.name,.id]]' |
  jq --raw-output '.[] | @tsv' |
  sed --silent 's/^segment-[0-9]*\t//p' |
  while read -r artifact_id
  do
    sleep 0.1s
    curl --location \
      --request DELETE \
      --header 'Accept: application/vnd.github+json' \
      --header "Authorization: Bearer ${GITHUB_TOKEN}" \
      --header 'X-GitHub-Api-Version: 2022-11-28' \
      "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts/${artifact_id}"
  done

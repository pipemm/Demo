#!/usr/bin/bash

function paginator() {
  local url=${1}
  curl --location \
    --header 'Accept: application/vnd.github+json' \
    --header "Authorization: Bearer ${GITHUB_TOKEN}" \
    --header 'X-GitHub-Api-Version: 2022-11-28' \
    --dump-header >(
      sed --silent 's/^link://p' |
      while IFS=',' read -r -a paginators
      do
        for pp in "${paginators[@]}"
        do
          echo "${pp}"
        done |
        sed --silent '/ rel="next"$/p' |
        sed --silent 's/^\s*<\(.*\)>;.*$/\1/p'
      done |
      head --lines=1 |
      while read -r nextpage
      do
        paginator "${nextpage}"
      done
      ) \
    "${url}" \
    --output >(
      jq '[.artifacts[] | [.name,.id]]' |
      jq --raw-output '.[] | @tsv'
    )
}

paginator "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}/artifacts" |
  sed --silent '/^segment-[0-9]\+\t/p' |
  sed 's/\t/ /' |
  while read -r line
  do
    filename="${line%% *}"
    artifact_id="${line#* }"
    ## sleep 0.1s
    echo "deleting ${filename} (${artifact_id})"
    curl --location \
      --request DELETE \
      --header 'Accept: application/vnd.github+json' \
      --header "Authorization: Bearer ${GITHUB_TOKEN}" \
      --header 'X-GitHub-Api-Version: 2022-11-28' \
      "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts/${artifact_id}"
  done

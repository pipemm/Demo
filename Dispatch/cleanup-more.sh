#!/usr/bin/bash

thisscript=$(realpath --canonicalize-existing "${0}")
thispath="${thisscript%/*}/"
cd "${thispath}"

filelist='artifactlist.txt'

curl --location \
  --header 'Accept: application/vnd.github+json' \
  --header "Authorization: Bearer ${GITHUB_TOKEN}" \
  --header 'X-GitHub-Api-Version: 2022-11-28' \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/artifacts" |
  jq '[.artifacts[] | [.name,.id]]' |
  jq --raw-output '.[] | @tsv' > "${filelist}"

cat "${filelist}" |
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

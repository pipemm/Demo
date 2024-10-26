#!/usr/bin/bash

if [[ -z "${UserAgent}" || -z "${URL_Base}" || -z "${VAR_Target}" ]]
then
  echo 'variable missing: UserAgent or URL_Base or VAR_Target'
  exit 1
fi

FolderDownload='Download/'
mkdir --parent "${FolderDownload%/}/"

function download_i () {
  local urli="${1}"
  curl "${urli}" \
    --header 'accept: text/html' \
    --header 'cache-control: no-cache' \
    --header "user-agent: ${UserAgent}" |
    sed --silent "s!^.*<script>window.${VAR_Target}=!!p" |
    sed --silent 's!</script>.*$!!p' |
    head --lines=1 |
    sed 's!^\(.*\)$!var initial_data = \1;!'
}

FileMainJS="${FolderDownload%/}/initial.js"
download_i "${URL_Base}" > "${FileMainJS}"

FolderJS='JavaScript/'
ScriptJ2J="${FolderJS%/}/js2json.js"

FolderOut='Output/'
mkdir --parent "${FolderOut%/}/"

FileMain="${FolderOut%/}/initial.json"
node "${ScriptJ2J}" "${FileMainJS}" 'initial_data' |
  jq > "${FileMain}"

FileChannel="${FolderOut%/}/channels.json"
cat "${FileMain}" |
  jq '.feed.channels.categories' > "${FileChannel}"

cat "${FileChannel}" |
  jq --raw-output '.[].id' |
  while read -r id
  do
    ifilen=$( echo "${id}" | tr --complement '[:alnum:]' '_' )
    ifile="initial_${ifilen%_}"
    filejs="${FolderDownload%/}/${ifile}.js"
    filejson="${FolderOut%/}/${ifile}.json"
    url="${URL_Base}?channel_id=${id}"
    download_i "${url}" > "${filejs}"
    node "${ScriptJ2J}" "${filejs}" 'initial_data' |
      jq > "${filejson}"
  done

FileList="${FolderOut%/}/URL.tsv"
echo id$'\t'displayTitle$'\t'channel > "${FileList}"
ls ${FolderOut%/}/i*.json |
  while read -r json
  do
    cat "${json}" |
      jq '.feed | {currentChannel: .currentChannel, feeds: [ .feeds[] | {id: [.id, "?xsec_token=", .xsecToken] | add, displayTitle: .noteCard.displayTitle} ]}' |
      jq '. as $feed | .feeds | [ .[] | {id, displayTitle, channel: $feed.currentChannel} ]' |
      jq '.[]|[.id, .displayTitle, .channel]' |
      jq  --raw-output '@tsv'
  done >> "${FileList}"

cat "${FileList}"


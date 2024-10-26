#!/usr/bin/bash

if [[ -z "${UserAgent}" || -z "${URL_Base}" || -z "${VAR_Target}" ]]
then
  echo 'variable missing: UserAgent or URL_Base or VAR_Target'
  exit 1
fi

FolderDownload='Download/'
mkdir --parent "${FolderDownload%/}/"

FileMainJS="${FolderDownload%/}/initial.js"
curl "${URL_Base}" \
  --header 'accept: text/html' \
  --header 'cache-control: no-cache' \
  --header "user-agent: ${UserAgent}" |
  sed --silent "s!^.*<script>window.${VAR_Target}=!!p" |
  sed --silent 's!</script>.*$!!p' |
  head --lines=1 |
  sed 's!^\(.*\)$!var initial_data = \1;!' > "${FileMainJS}"

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
    ifile="i_${ifilen%_}.js"
    filejs="${FolderDownload%/}/${ifile}"
    url="${URL_Base}?channel_id=${id}"
    echo "${filejs}"
  done


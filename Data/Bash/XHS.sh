#!/usr/bin/bash

if [[ -z "${UserAgent}" || -z "${XHS_URL_Base}" || -z "${XHS_VAR_Target}" ]]
then
  echo 'variable missing: UserAgent or XHS_URL_Base or XHS_VAR_Target'
  exit 1
fi

FolderDownload='Download/'
mkdir --parent "${FolderDownload%/}/"

FileMainJS="${FolderDownload%/}/initial.js"
curl "${XHS_URL_Base}" \
  --header 'accept: text/html' \
  --header 'cache-control: no-cache' \
  --header "user-agent: ${UserAgent}" |
  sed --silent "s!^.*<script>window.${XHS_VAR_Target}=!!p" |
  sed --silent 's!</script>.*$!!p' |
  head --lines=1 |
  sed 's!^\(.*\)$!var initial_data = \1;!' > "${FileMainJS}"

FolderJS='JavaScript/'
ScriptJ2J="${FolderJS%/}/js2json.js"

FolderJSON='JSON/'
mkdir --parent "${FolderJSON%/}/"

FileMain="${FolderJSON%/}/initial.json"
node "${ScriptJ2J}" "${FileMainJS}" 'initial_data' |
  jq > "${FileMain}"



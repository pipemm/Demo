#!/usr/bin/bash

thisscript=`realpath "${0}"`
thispath="${thisscript%/*}/"
cd "${thispath}"

which jq 1>/dev/null 2>&1
if [[ "$?" -eq 0 ]]
then
  echo 'jq'
  exit
fi

## using the default jq version in AWS CloudShell, as of 2023-06
## https://github.com/jqlang/jq/releases/tag/jq-1.5
urljq='https://github.com/jqlang/jq/releases/download/jq-1.5/jq-linux64'

jqpath=`pwd`
jqpath="${jqpath%/}/${urljq##*/}"

if [[ ! -f "${jqpath}" ]]
then
  curl --output "${jqpath}" --location "${urljq}"
  chmod a+x "${jqpath}"
fi

echo "${jqpath}"

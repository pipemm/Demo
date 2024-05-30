#!/usr/bin/bash

thisscript=$(realpath "${0}")
thispath="${thisscript%/*}/"
cd "${thispath}"

url_index='https://create.microsoft.com/search?filters=excel'
url_template='https://create.microsoft.com/template/'

folder_template='Template/'
mkdir --parent "${folder_template%/}/"

python3 get_template_list.py 'QL/query.graphql' |
  while read -r line
  do
    url_page="${url_template%/}/${line%%   *}"
    filename="${line##*   }.xlsx"
    echo "visiting ${url_page}"
    url_file=$(
      curl --location "${url_page}" |
      sed --silent 's!^.*"link":"\([^"]*\.xlsx\)".*$!\1!p' |
      head --lines=1
    )
    echo "  saving ${filename}"
    echo "  from ${url_file}"
    curl --output "${folder_template%/}/${filename}" "${url_file}"
  done


#!/usr/bin/bash

url_index='https://create.microsoft.com/search?filters=excel'
url_template='https://create.microsoft.com/template/'
##curl "${url_index}"

folder_template='Template/'
mkdir --parent "${folder_template%/}/"

python3 get_template_list.py |
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

  ## sed --silent 's!^.*"name":"\([^"]*\)".*$!\1!p'

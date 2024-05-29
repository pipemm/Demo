#!/usr/bin/bash

url_index='https://create.microsoft.com/search?filters=excel'
url_template='https://create.microsoft.com/template/'
##curl "${url_index}"


python3 get_template_list.py |
  while read -r line
  do
    url_page="${url_template%/}/${line}"
    echo "visiting ${url_page}"
    curl --location "${url_page}"
  done > test2.txt

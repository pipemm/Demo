#!/usr/bin/bash

url_index='https://create.microsoft.com/en-us/search?filters=excel'

##curl "${url_index}"


python3 get_template_list.py > test.txt

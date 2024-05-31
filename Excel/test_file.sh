#!/usr/bin/bash

thisscript=$(realpath "${0}")
thispath="${thisscript%/*}/"
cd "${thispath}"

folder_template='Template/'
ls "${folder_template%/}/"*.xlsx |
  while read -r xlsxfile
  do
    md5sum "${xlsxfile}"
    zipinfo -vh "${xlsxfile}"
  done



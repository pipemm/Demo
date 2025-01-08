#!/usr/bin/bash

thisscript=$(realpath --canonicalize-existing "${0}")
thispath="${thisscript%/*}/"
cd "${thispath}"

FolderResult='combine/'
mkdir --parent "${FolderResult%/}/"
cat segment/*.txt |
  tee "${FolderResult%/}/list.txt"

#!/usr/bin/bash

thisscript=$(realpath --canonicalize-existing "${0}")
thispath="${thisscript%/*}/"
cd "${thispath}"

if [[ ! -n "${Prefix}" ]]
then
  exit 1
fi

if [[ ! -n "${Number}" ]]
then
  exit 1
fi

if [[ ! -n "${Segment}" ]]
then
  exit 1
fi

folderlog='segment/'
mkdir --parent "${folderlog%/}/"
seg="${Segment}000"
snumber=$(( Number + seg ))
sname="segment-${snumber}"
filelog="${folderlog%/}/${sname}.txt"

for iid in {0..999}
do
  id=$(( snumber + iid ))
  url="${Prefix%/}/${id}"
  curl --silent --head "${url}" |
    sed --silent '/^content-disposition:/p' |
    while read -r hd
    do
      filename="${hd#*filename=}"
      echo "${id} ${filename}"
    done
done | 
  tee "${filelog}"

if [[ -n "${GITHUB_ENV}" ]]
then
  echo "sname=${sname}" |
    tee --append "${GITHUB_ENV}"
fi

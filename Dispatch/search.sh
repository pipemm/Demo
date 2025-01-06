#!/usr/bin/bash

thisscript=$(realpath --canonicalize-existing "${0}")
thispath="${thisscript%/*}/"
cd "${thispath}"

if [[ ! -n "${Prefix}" ]]
then
  exit 1
fi

if [[ ! -n "${Segment}" ]]
then
  exit 1
fi

folderlog='segment/'
mkdir --parent "${folderlog%/}/"
filelog="${folderlog%/}/segment-${Segment}.txt"

for iid in {0..99}
do
  id=$(( Segment + iid ))
  echo "${id}"
  url="${Prefix%/}/${id}"
  curl --silent --head "${url}" |
    sed --silent '/^content-disposition:/p' |
    while read -r hd
    do
      filename="${hd##*filename=}"
      echo "${id} ${filename}" | 
        tee "${filelog}"
    done
done



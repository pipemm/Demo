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

for iid in {0..99}
do
  id=$(( SEGMENT + iid ))
  echo "${id}"
done



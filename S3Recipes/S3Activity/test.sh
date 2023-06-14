#!/usr/bin/bash

thisscript=`realpath "${0}"`
thispath="${thisscript%/*}/"
cd "${thispath}"

bucket='s3-bucket-name'
prefix='prefix/'
testdate='2023-04-19'

jq=`bash utility/getjq.sh`

sedfilter='1p; /^"__DATE__/p'
sedfilter="${sedfilter//__DATE__/${testdate}}"

echo 'TESTING 1'

bash s3activity_v1.sh "${bucket}" "${prefix}" |
  "${jq}" '[.Versions[],.DeleteMarkers[]]' |
  "${jq}" 'sort_by(.LastModified) | reverse' |
  "${jq}" '.[] | [.LastModified,.VersionId]' |
  (echo 'LastModified,VersionId' & "${jq}" --raw-output '@csv') |
  sed --silent "${sedfilter}"

echo 

echo 'TESTING 2'

bash s3activity_v2.sh "${bucket}" "${prefix}" |
  "${jq}" '.[] | [.LastModified,.VersionId]' |
  (echo 'LastModified,VersionId' & "${jq}" --raw-output '@csv') |
  sed --silent "${sedfilter}"

echo


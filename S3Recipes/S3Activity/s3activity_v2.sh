#!/usr/bin/bash

## measure activity frequency in a versioning-enabled s3 bucket

S3Bucket="${1}"
S3Prefix="${2}"

if [[ -z "${S3Bucket}" ]]
then
  exit
fi

JMESPath='[DeleteMarkers,Versions][] | [].{LastModified:LastModified,VersionId:VersionId} | reverse(sort_by(@,&LastModified))'

if [[ -n "${S3Prefix}" ]]
then
  aws s3api list-object-versions \
    --bucket "${S3Bucket}" \
    --prefix "${S3Prefix}" \
    --query "${JMESPath}"
else
  aws s3api list-object-versions \
    --bucket "${S3Bucket}" \
    --query "${JMESPath}"
fi
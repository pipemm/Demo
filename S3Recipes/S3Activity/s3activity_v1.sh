#!/usr/bin/bash

## measure activity frequency in a versioning-enabled s3 bucket

S3Bucket="${1}"
S3Prefix="${2}"

if [[ -z "${S3Bucket}" ]]
then
  exit
fi

if [[ -n "${S3Prefix}" ]]
then
  aws s3api list-object-versions \
    --bucket "${S3Bucket}" \
    --prefix "${S3Prefix}"
else
  aws s3api list-object-versions \
    --bucket "${S3Bucket}"
fi
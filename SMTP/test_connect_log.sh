#!/usr/bin/bash

thisscript=`realpath "${0}"`
thispath="${thisscript%/*}/"
cd "${thispath}"

logfile='info_connect.log'

echo > "${logfile}"

bash test_connect_aws.sh   2>&1 >> "${logfile}"

bash test_connect_gmail.sh 2>&1 >> "${logfile}"



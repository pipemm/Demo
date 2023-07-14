#!/usr/bin/bash

SMTP_SERVER='smtp.gmail.com'

## SMTP/test_connect_aws.sh

openssl s_client -connect "${SMTP_SERVER}:465" -crlf -ign_eof <<END_OF_FILE
EHLO email.client
QUIT
END_OF_FILE

openssl s_client -connect "${SMTP_SERVER}:587" -starttls smtp -crlf -ign_eof <<END_OF_FILE
EHLO email.client
QUIT
END_OF_FILE

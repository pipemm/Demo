
```bash
SMTP_SERVER='email-smtp.eu-west-1.amazonaws.com'

openssl s_client -connect "${SMTP_SERVER}:25" -starttls smtp -crlf -ign_eof <<END_OF_FILE
EHLO report.client
QUIT
END_OF_FILE

openssl s_client -connect "${SMTP_SERVER}:465" -crlf -ign_eof <<END_OF_FILE
EHLO report.client
QUIT
END_OF_FILE

openssl s_client -connect "${SMTP_SERVER}:587" -starttls smtp -crlf -ign_eof <<END_OF_FILE
EHLO report.client
QUIT
END_OF_FILE

```

#!/bin/bash

URL_UnicodeCharacterDatabase='https://www.unicode.org/Public/UCD/latest/'
URL_NameList="${URL_UnicodeCharacterDatabase%/}/ucd/NamesList.txt"
URL_XML_ZIP="${URL_UnicodeCharacterDatabase%/}/ucdxml/ucd.all.flat.zip"

curl "${URL_XML_ZIP}" | 
  funzip |
  sed --silent '/1B11F/,$p' |
  python3 ./download_import.sh |
  head --lines=10 

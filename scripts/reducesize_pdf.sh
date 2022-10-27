#!/bin/bash
# https://www.redhat.com/sysadmin/process-script-inputs
if [ $# -eq 0 ];
then
  echo "$0: Missing arguments"
  exit 1
elif [ $# -gt 1 ];
then
  echo "$0: Too many arguments: $@"
  exit 1
else
  # reduce the file size using `ebook` setting
  gs -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/ebook \
    -dNOPAUSE \
    -dQUIET \
    -dBATCH \
    -sOutputFile="${1%%.*}_red.pdf" \
    $1
fi
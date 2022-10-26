#!/bin/bash
# https://www.redhat.com/sysadmin/process-script-inputs
if [ $# -eq 0 ];
then
  echo "$0: Missing arguments"
  exit 1
elif [ $# -gt 3 ];
then
  echo "$0: Too many arguments: $@"
  exit 1
else
# scale PDF to desired format using Ghostscript (gs);
# `\` and newline is used for nicer formatting while
# supplying all options to the gc binary
# run `gs --help` for seeing all available options
# options for sPAPERSIZE are for example a4 or a5
  # https://tex.stackexchange.com/questions/144268/need-to-rescale-a-complex-document-page-size-and-fonts-to-a5-from-a4
  echo "Scaling file $1 to format $3"
  gs -q -dNOPAUSE \
    -dBATCH \
    -sDEVICE=pdfwrite \
    -sPAPERSIZE=$3 \
    -dFIXEDMEDIA \
    -dPDFFitPage \
    -dCompatibilityLevel=1.4 \
    -sOutputFile="${1%%.*}-$3.pdf" \
    "$1"
fi
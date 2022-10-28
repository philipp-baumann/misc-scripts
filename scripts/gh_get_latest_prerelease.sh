#!/bin/bash
if [ $# -eq 0 ];
then
  echo "$0: Missing arguments"
  exit 1
elif [ $# -gt 1 ];
then
  echo "$0: Too many arguments: $@"
  exit 1
else
  # from https://stackoverflow.com/questions/67688662/how-can-i-get-the-latest-pre-release-release-for-my-github-repo-bash
  jq -r 'map(select(.prerelease)) | first | .tag_name' \
    <<< $(curl --silent https://api.github.com/repos/$1/releases)
fi
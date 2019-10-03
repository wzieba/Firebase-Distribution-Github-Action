#!/bin/sh

MESSAGE="";
if [[ -z $INPUT_RELEASENOTES ]]; then
        MESSAGE="$(git log -1 --pretty=short)"
else
        MESSAGE=$INPUT_RELEASENOTES
fi

firebase appdistribution:distribute "$INPUT_FILE" --app "$INPUT_APPID" --token "$INPUT_TOKEN" --groups "$INPUT_GROUPS" --release-notes "$MESSAGE"


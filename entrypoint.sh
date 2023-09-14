#!/bin/bash

# Required since https://github.blog/2022-04-12-git-security-vulnerability-announced
git config --global --add safe.directory $GITHUB_WORKSPACE

RELEASE_NOTES=""
RELEASE_NOTES_FILE=""

TOKEN_DEPRECATED_WARNING_MESSAGE="⚠ This action will stop working with the next future major version of firebase-tools! Migrate to Service Account. See more: https://github.com/wzieba/Firebase-Distribution-Github-Action/wiki/FIREBASE_TOKEN-migration"

if [[ -z ${INPUT_RELEASENOTES} ]]; then
        RELEASE_NOTES="$(git log -1 --pretty=short)"
else
        RELEASE_NOTES=${INPUT_RELEASENOTES}
fi

if [[ ${INPUT_RELEASENOTESFILE} ]]; then
        RELEASE_NOTES=""
        RELEASE_NOTES_FILE=${INPUT_RELEASENOTESFILE}
fi

if [ -n "${INPUT_SERVICECREDENTIALSFILE}" ] ; then
    export GOOGLE_APPLICATION_CREDENTIALS="${INPUT_SERVICECREDENTIALSFILE}"
fi

if [ -n "${INPUT_SERVICECREDENTIALSFILECONTENT}" ] ; then
    cat <<< "${INPUT_SERVICECREDENTIALSFILECONTENT}" > service_credentials_content.json
    export GOOGLE_APPLICATION_CREDENTIALS="service_credentials_content.json"
fi

if [ -n "${INPUT_TOKEN}" ] ; then
    echo ${TOKEN_DEPRECATED_WARNING_MESSAGE}
    export FIREBASE_TOKEN="${INPUT_TOKEN}"
fi

firebase \
        appdistribution:distribute \
        "$INPUT_FILE" \
        --app "$INPUT_APPID" \
        --groups "$INPUT_GROUPS" \
        --testers "$INPUT_TESTERS" \
        ${RELEASE_NOTES:+ --release-notes "${RELEASE_NOTES}"} \
        ${INPUT_RELEASENOTESFILE:+ --release-notes-file "${RELEASE_NOTES_FILE}"} \
	$( (( $INPUT_DEBUG )) && printf %s '--debug' ) |
{
    # initialize variables
    CONSOLE_URI=""
    TESTING_URI=""
    BINARY_URI=""

    while read -r line
    do
	echo $line

        if [[ $line == *"View this release in the Firebase console"* ]]; then
            CONSOLE_URI=$(echo "$line" | sed -e 's/View this release in the Firebase console: //')
            CONSOLE_URI=${CONSOLE_URI%?}
            export CONSOLE_URI
        elif [[ $line == *"Share this release with testers who have access"* ]]; then
            TESTING_URI=$(echo "$line" | sed -e 's/Share this release with testers who have access: //')
            TESTING_URI=${TESTING_URI%?}
            export TESTING_URI
        elif [[ $line == *"Download the release binary"* ]]; then
            BINARY_URI=$(echo "$line" | sed -e 's/Download the release binary (link expires in 1 hour): //')
            BINARY_URI=${BINARY_URI%?}
            export BINARY_URI
        fi
    done

    # if firebase deploy failed, return error
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # test by echoing the variables
    echo "Firebase Console URI: $CONSOLE_URI"
    echo "Testing URI: $TESTING_URI"
    echo "Binary Download URI: $BINARY_URI"
}


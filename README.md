# Firebase App Distribution Github Action

<a href="https://github.com/wzieba/Firebase-Distribution-Github-Action/actions">![](https://github.com/wzieba/Firebase-Distribution-Github-Action/workflows/Sample%20workflow%20for%20Firebase%20Distribution%20action/badge.svg)</a>
<a href="https://github.com/wzieba/Firebase-Distribution-Github-Action/releases">![](https://img.shields.io/github/v/release/wzieba/Firebase-Distribution-Github-Action)</a>

This action uploads artifacts (.apk,.aab or .ipa) to Firebase App Distribution.

## Inputs

### `appId`

**Required** App id can be found on the General Settings page

### `token`

⚠️ Deprecated! Don't use it. Firebase team deprecated this option and it will soon be removed.

Use `serviceCredentialsFileContent` instead. [Learn here how to generate one](https://github.com/wzieba/Firebase-Distribution-Github-Action/wiki/FIREBASE_TOKEN-migration).

~**Required** Upload token - see Firebase CLI Reference (tldr; run `firebase login:ci` command to get your token).~

### `serviceCredentialsFileContent`
**Required** Content of Service Credentials private key JSON file. [Learn here how to generate one](https://github.com/wzieba/Firebase-Distribution-Github-Action/wiki/FIREBASE_TOKEN-migration).

### `serviceCredentialsFile`

**Required** Service Credentials File - The path or HTTP URL to your Service Account private key JSON file.
Required only if you don't use `serviceCredentialsFileContent`.

### `file`

**Required** Artifact to upload (.apk, .aab or .ipa)

### `groups`

Distribution groups

### `releaseNotes`

Release notes visible on release page. If not specified, plugin will add last commit's
 - hash
 - author
 - message
 
### `releaseNotesFile`

Specify the release note path to a plain text file.

### `debug`

Flag that can be included to print verbose log output. Default value is `false`

## Sample usage

```
name: Build & upload to Firebase App Distribution 

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
    - name: set up JDK 1.8
      uses: actions/setup-java@v1
      with:
        java-version: 1.8
    - name: build release 
      run: ./gradlew assembleRelease
    - name: upload artifact to Firebase App Distribution
      uses: wzieba/Firebase-Distribution-Github-Action@v1
      with:
        appId: ${{secrets.FIREBASE_APP_ID}}
        serviceCredentialsFileContent: ${{ secrets.CREDENTIAL_FILE_CONTENT }}
        groups: testers
        file: app/build/outputs/apk/release/app-release-unsigned.apk
```

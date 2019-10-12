# Firebase Distribution Github Action

This action uploads artefacts (.apk or .ipa) to Firebase Distribution.

## Inputs

### `appId`

**Required** App id can be found on the General Settings page

### `token`

**Required** Upload token - see Firebase CLI Reference

### `file`

**Required** Artefact to upload (.apk or .ipa)

### `groups`

Distribution groups

### `releaseNotes`

Release notes visible on release page. If not specified, plugin will add last commit's
 - hash
 - author
 - message



## Example usage

```
name: Build, code quality, tests 

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
    - name: upload artefact to Firebase Distribution
      uses: wzieba/Firebase-Distribution-Github-Action@v1.0.0
      with:
        appId: ${{secrets.FIREBASE_APP_ID}}
        token: ${{secrets.FIREBASE_TOKEN}}
        group: testers
        file: app/build/outputs/apk/release/app-release-unsigned.apk
```

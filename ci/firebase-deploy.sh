#!/bin/bash

# Exit on any error
set -e

# Support for Firebase App Distribution
# Required environment variables:
# FIREBASE_APP_ID: The App ID for Firebase
# FIREBASE_TOKEN: (Optional if using FIREBASE_SERVICE_ACCOUNT_KEY)
# GOOGLE_APPLICATION_CREDENTIALS: (Optional, path to service account key)

APK_SOURCE="build/app/outputs/flutter-apk/app-release.apk"

if [[ ! -f "$APK_SOURCE" ]]; then
    echo "Error: APK not found at $APK_SOURCE"
    exit 1
fi

if [[ -n "$FIREBASE_OUTPUT_APK" ]]; then
    echo "Renaming APK to $FIREBASE_OUTPUT_APK"
    mv "$APK_SOURCE" "$FIREBASE_OUTPUT_APK"
    APK_PATH="$FIREBASE_OUTPUT_APK"
else
    APK_PATH="$APK_SOURCE"
fi

echo "Deploying to Firebase App Distribution..."

# If FIREBASE_SERVICE_ACCOUNT_KEY is present, write it to a file
if [[ -n "$FIREBASE_SERVICE_ACCOUNT_KEY" ]]; then
    echo "$FIREBASE_SERVICE_ACCOUNT_KEY" > firebase-key.json
    export GOOGLE_APPLICATION_CREDENTIALS=$(pwd)/firebase-key.json
fi

firebase appdistribution:distribute "$APK_PATH" \
    --app "$FIREBASE_APP_ID" \
    ${FIREBASE_GROUPS:+--groups "$FIREBASE_GROUPS"} \
    ${FIREBASE_RELEASE_NOTES:+--release-notes "$FIREBASE_RELEASE_NOTES"}

# Cleanup
if [[ -f "firebase-key.json" ]]; then
    rm firebase-key.json
fi

echo "Firebase deployment completed successfully."

#!/bin/bash

# Exit on any error
set -e

# Support for Firebase App Distribution
# Required environment variables:
# FIREBASE_APP_ID: The App ID for Firebase
# FIREBASE_TOKEN: (Optional if using FIREBASE_SERVICE_ACCOUNT_KEY)
# GOOGLE_SERVICE_KEY: (Optional, path to service account key)

if [[ ! -f "$APP_OUTPUT" ]]; then
    echo "Error: APK not found at $APP_OUTPUT"
    exit 1
fi

if [[ -n "$FIREBASE_OUTPUT_APK" ]]; then
    echo "Renaming APK to $FIREBASE_OUTPUT_APK"
    mv "$APP_OUTPUT" "$FIREBASE_OUTPUT_APK"
    APK_PATH="$FIREBASE_OUTPUT_APK"
else
    APK_PATH="$APP_OUTPUT"
fi

echo "Deploying to Firebase App Distribution..."

# Handle GOOGLE_SERVICE_KEY
if [[ -n "$GOOGLE_SERVICE_KEY" ]]; then
    if [[ -f "$GOOGLE_SERVICE_KEY" ]]; then
        echo "Using GOOGLE_SERVICE_KEY from file path: $GOOGLE_SERVICE_KEY"
    else
        echo "GOOGLE_SERVICE_KEY is not a file, assuming raw JSON content..."
        echo "$GOOGLE_SERVICE_KEY" > firebase-key.json
        export GOOGLE_SERVICE_KEY=$(pwd)/firebase-key.json
        CLEANUP_KEY=true
    fi
elif [[ -n "$FIREBASE_SERVICE_ACCOUNT_KEY" ]]; then
    echo "Using FIREBASE_SERVICE_ACCOUNT_KEY..."
    echo "$FIREBASE_SERVICE_ACCOUNT_KEY" > firebase-key.json
    export GOOGLE_SERVICE_KEY=$(pwd)/firebase-key.json
    CLEANUP_KEY=true
fi

firebase appdistribution:distribute "$APK_PATH" \
    --app "$FIREBASE_APP_ID" \
    ${FIREBASE_GROUPS:+--groups "$FIREBASE_GROUPS"} \
    ${FIREBASE_RELEASE_NOTES:+--release-notes "$FIREBASE_RELEASE_NOTES"}

# Cleanup
if [[ "$CLEANUP_KEY" = true ]]; then
    rm -f firebase-key.json
fi

echo "Firebase deployment completed successfully."

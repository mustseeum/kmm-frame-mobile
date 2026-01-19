#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

mkdir -p trivy .trivycache

# Full image reference (avoid overwriting IMAGE_NAME variable)
IMAGE_REGISTRY="${DOCKER_REGISTRY}/${IMAGE_NAME}"
BUILD_TAG="$IMAGE_REGISTRY:$IMAGE_TAG"
LATEST_TAG="$IMAGE_REGISTRY:latest"

echo "Trivy image scan for: $BUILD_TAG"
trivy --version || true

# cache cleanup is needed when scanning images with the same tags, it does not remove the database
trivy clean --scan-cache

echo "Generate Trivy Docker scan json Report..."
trivy image \
  --scanners vuln \
  --cache-dir .trivycache/ \
  --severity HIGH,CRITICAL \
  --format json -o "$CI_PROJECT_DIR/trivy/trivy-image-${CI_COMMIT_SHORT_SHA}.json" \
  "$BUILD_TAG"

echo "Generate Trivy Docker scan sarif Report..."
trivy image \
  --scanners vuln \
  --cache-dir .trivycache/ \
  --severity HIGH,CRITICAL \
  --format sarif -o "$CI_PROJECT_DIR/trivy/trivy-image-${CI_COMMIT_SHORT_SHA}.sarif" \
  "$BUILD_TAG"

echo "Scanning Docker Image..."
trivy image \
  --scanners vuln \
  --cache-dir .trivycache/ \
  --severity HIGH,CRITICAL --exit-code 1 \
  "$BUILD_TAG"
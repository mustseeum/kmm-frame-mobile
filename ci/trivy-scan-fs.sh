#!/bin/bash
set -e
mkdir -p trivy .trivycache
##Begin Scanning
echo "Check trivy version"
trivy --version 

# cache cleanup is needed when scanning images with the same tags, it does not remove the database
trivy clean --scan-cache

echo "Generate Trivy File System json Report..."
trivy fs \
  --scanners vuln \
  --cache-dir .trivycache/ \
  --severity HIGH,CRITICAL\
  --format json -o "$CI_PROJECT_DIR/trivy/trivy-fs-${CI_COMMIT_SHORT_SHA}.json" \
  "$CI_PROJECT_DIR"

echo "Generate Trivy File System sarif Report..."
trivy fs \
  --scanners vuln \
  --cache-dir .trivycache/ \
  --severity HIGH,CRITICAL\
  --format sarif -o "$CI_PROJECT_DIR/trivy/trivy-fs-${CI_COMMIT_SHORT_SHA}.sarif" \
  "$CI_PROJECT_DIR"

echo "Scanning Current Repository"
trivy fs \
  --scanners vuln \
  --skip-files ".env" \
  --cache-dir .trivycache/ \
  --severity HIGH,CRITICAL --exit-code 1\
  "$CI_PROJECT_DIR"
#!/bin/bash

# Environment List Available
# INFISICAL_URL = https://secret.idstar.group/
# INFISICAL_PROJECT_ID = infisical project id
# INFISICAL_ENV_PATH = /path/to/project-group
# INFISICAL_ENVIRONMENT = dev | staging | prod
# INFISICAL_CLIENT_ID = Machine Identity Client ID (Global Applied in Gitlab Admin deployment/CD Variable for gitlab-runner)
# INFISICAL_CLIENT_SECRET = Machine Identity Secret Token (Global Applied in Gitlab Admin deployment/CD Variable for gitlab-runner)
# GITLAB_INFISICAL_CLI_VERSION = Infisical CLI Version (Global Applied in Gitlab Admin deployment/CD Variable for gitlab-runner)
  
# Exit on any error
set -e

# Trap to ensure cleanup happens even if script fails
cleanup() {
  echo "Clearing Infisical Token and other sensitive variables..."
  unset INFISICAL_URL
  unset INFISICAL_ENV_PATH
  unset INFISICAL_CLIENT_SECRET
  unset INFISICAL_ENVIRONMENT
  unset INFISICAL_TOKEN
  unset INFISICAL_CLIENT_ID
}
trap cleanup EXIT

infisical --version

# Start Infisical Setup (Migrate to taufiq14s/infisical-cli)

# echo "Install prerequisite"
# apt-get update && apt-get install -y sudo curl gnupg apt-transport-https apt-utils

# echo "Add Infisical Repository"

# curl -1sLf \
# 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' \
# | sudo -E bash

# echo "Install Infisical CLI"
# sudo apt-get update && sudo apt-get install -y infisical=${GITLAB_INFISICAL_CLI_VERSION:-0.31.0}

echo "Set Infisical Default Variables"
INFISICAL_ENV_PATH=${INFISICAL_ENV_PATH:-"/"}
INFISICAL_ENVIRONMENT=${INFISICAL_ENVIRONMENT:-"staging"}

echo "Logging into Infisical with Machine Identity..."
export INFISICAL_TOKEN=$(infisical login --domain="${INFISICAL_URL}" --method=universal-auth --client-id="${INFISICAL_CLIENT_ID}" --client-secret="${INFISICAL_CLIENT_SECRET}" --silent --plain)

echo "Writing .env file..."
infisical export --token="${INFISICAL_TOKEN}" --env="${INFISICAL_ENVIRONMENT}" --domain="${INFISICAL_URL}" --projectId="${INFISICAL_PROJECT_ID}" --path="${INFISICAL_ENV_PATH}" > .env

# Load .env file
source .env

# Clear token and sensitive variables as part of cleanup
echo "Clear Infisical Token"
cleanup

echo "Script execution completed successfully."

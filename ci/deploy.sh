#!/bin/bash

# Instructs the shell to exit immediately if any command or pipeline returns a non-zero exit status, which usually indicates an error or failure
set -e
IMAGE_REGISTRY="${DOCKER_REGISTRY}/${IMAGE_NAME}"
BUILD_TAG="$IMAGE_REGISTRY:$IMAGE_TAG"
LATEST_TAG="$IMAGE_REGISTRY:latest"
DOCKER_SSH_PORT=${DOCKER_SSH_PORT:-22}

command -v ssh-agent > /dev/null || (apk update && apk add -q openssh)
mkdir -p ~/.ssh
chmod 700 ~/.ssh
eval "$(ssh-agent -s)"
if [[ -f /.dockerenv ]]; then
    cat > ~/.ssh/config <<EOL
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOL
    chmod 600 ~/.ssh/config
fi
echo "$DOCKER_HOST_SECRET_KEY_base64" | tr -d '\n' | base64 -d > ~/.ssh/secret_key
chmod 600 ~/.ssh/secret_key
ssh-add ~/.ssh/secret_key

# Function to run commands on remote server
run_ssh_command() {
    ssh -o StrictHostKeyChecking=no -p "$DOCKER_SSH_PORT" "$DOCKER_USER@$DOCKER_HOST" "$@"
}

# # Set AWS credentials and log in to Docker registry (use amazon-ecr-credential-helper)
# echo "Setting AWS credentials on the server and logging into Docker registry..."
# run_ssh_command "
#     aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID &&
#     aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY &&
#     aws configure set region $AWS_REGION &&
#     aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $DOCKER_REGISTRY
# "

# Create Docker Compose Folder If not existing
run_ssh_command "
    mkdir -p $DOCKER_COMPOSE_PATH/$DOCKER_COMPOSE_PATH_ENV &&
    echo 'Created $DOCKER_COMPOSE_PATH/$DOCKER_COMPOSE_PATH_ENV Folder'
"

# Stop and remove all containers
echo "Stopping and removing all containers..."
run_ssh_command "
    cd $DOCKER_COMPOSE_PATH/$DOCKER_COMPOSE_PATH_ENV &&
    docker compose down || true
"

# Copy necessary files to the server
echo "Updating .env file with the new image tag..."
sed -i "s|^APP_VER=.*|APP_VER='"$IMAGE_TAG"'|" .env
scp -P "$DOCKER_SSH_PORT" .env "$DOCKER_USER@$DOCKER_HOST:$DOCKER_COMPOSE_PATH/$DOCKER_COMPOSE_PATH_ENV"

# Adding a delay to ensure all containers are stopped
sleep 3

# Start container service
echo "Starting container service..."

run_ssh_command '
    cd '"$DOCKER_COMPOSE_PATH/$DOCKER_COMPOSE_PATH_ENV"'
    docker compose pull
    docker compose down
    docker compose up -d --force-recreate --no-build
    docker compose ps
    docker image prune -af
    exit
'

# Clean up SSH key
echo "Cleaning up..."
ssh-agent -k
rm -f ~/.ssh/secret_key
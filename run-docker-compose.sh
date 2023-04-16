#!/bin/bash

# Update .env file with random password
sed -i -e 's:^\(REDIS_PASSWORD\)=\(.*\)$:openssl rand -base64 32 | xargs echo \1=$1 | sed s," ",,g:e' .env

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
echo "Docker is not installed. Please install Docker and try again."
exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
echo "Docker Compose is not installed. Please install Docker Compose and try again."
exit 1
fi

# Build docker-compose
docker-compose build --no-cache --pull --compress --parallel --quiet 

# Run docker-compose
docker-compose up -d

# Check if the container was started successfully
if docker ps | grep -q 'redis'; then
echo "The Redis container was started successfully."
else
echo "An error occurred while starting the Redis container."
exit 1
fi

# Pause for user input
read -n1 -rsp $'Press any key to continue...\n'

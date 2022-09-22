#!/bin/bash

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]
then
  echo "ERROR: Empty project name!"
  echo "Ex: ./deploy.sh <project-name>"
  exit 1
fi

echo "Starting project $PROJECT_NAME with docker"

echo "Docker container name: $PROJECT_NAME";
docker-compose --project-name=$PROJECT_NAME build
docker-compose --project-name=$PROJECT_NAME down
docker-compose --project-name=$PROJECT_NAME up -d

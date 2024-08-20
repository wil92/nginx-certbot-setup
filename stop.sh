#!/bin/bash

PROJECT_NAME=$1

# get project name from file
if [ -f .project ] && [ -z "$PROJECT_NAME" ]
then
  PROJECT_NAME_FILE=$(cat .project)
  if [ ! -z "$PROJECT_NAME_FILE" ]
  then
    PROJECT_NAME=$PROJECT_NAME_FILE
  fi
fi

if [ -z "$PROJECT_NAME" ]
then
  echo "ERROR: Empty project name!"
  echo "Ex: ./stop.sh <project-name>"
  exit 1
else
  # save project name in file
  echo $PROJECT_NAME > .project
fi

echo "Docker container name: $PROJECT_NAME";
docker-compose --project-name=$PROJECT_NAME down

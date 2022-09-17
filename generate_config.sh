#!/bin/bash

CONFIG_BASE="$(cat nginx-config/nginx.binary.prod.conf)"

if [ -f .env ]
then
  set -a && source .env && set +a
fi

env -0 | while IFS='=' read -r -d '' n v; do
  if [[ "$CONFIG_BASE" == *"<$n>"* ]]; then
    CONFIG_BASE="$(echo "$CONFIG_BASE" | sed "s/<$n>/$v/g")"
    echo "$CONFIG_BASE" > nginx-config/config/nginx.conf
  fi
done

echo "nginx.config file was created."

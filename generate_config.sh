#!/bin/bash

CONFIG_NAME=$1
CONFIG_FILES=($(ls nginx-config | grep .conf))

FLAG=0
for FILE in "${CONFIG_FILES[@]}"
do :
  if [[ "$FILE" == "$CONFIG_NAME" ]] ; then
    FLAG=1
    break
  fi
done

if (( $FLAG == 0 )); then
  CONFIG_NAME=""
fi

while : ; do
  if [[ -z "$CONFIG_NAME" ]]; then
    i=0
    echo "Select the configuration number:"
    for FILE in "${CONFIG_FILES[@]}"
    do :
      i=$(($i+1))
      echo "$i. $FILE"
    done
    read SELECTION
    SELECTION=$((SELECTION-1))
    if (( $SELECTION < $i )) && (( $SELECTION >= 0 )) ; then
      CONFIG_NAME=${CONFIG_FILES[SELECTION]}
      break
    else
      echo "Invalid value!"
    fi
  else
    break
  fi
done

CONFIG_BASE="$(cat nginx-config/$CONFIG_NAME)"

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

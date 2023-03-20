#!/bin/bash

if [ -f .env ]
then
  export $(cat .env | xargs)
fi

sudo rm "$CERTBOT_CERT_PATH/live/$DOMAIN/privkey.pem"
sudo rm "$CERTBOT_CERT_PATH/live/$DOMAIN/fullchain.pem"

echo "The script will continuing with the certbot configuration."

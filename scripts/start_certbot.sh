#!/bin/bash

NEW_CERT_FLAG="/etc/letsencrypt/certbot.flag"

if ! [ -f "$NEW_CERT_FLAG" ]; then
  echo "Initial cert are going to be created"
  touch $NEW_CERT_FLAG

  RSA_KEY_SIZE=2048

  # recreate the fresh certificates
  echo "-recreate the fresh certificates"
  DOMAINS_ARGS=""
  for DOMAIN_IT in $DOMAINS
  do
    DOMAINS_ARGS=" $DOMAINS_ARGS -d $DOMAIN_IT"
  done
  certbot certonly --webroot -w /var/www/certbot $DOMAINS_ARGS \
    --email $EMAIL \
    --rsa-key-size $RSA_KEY_SIZE \
    --agree-tos \
    --force-renewal
fi

while : ; do
  sleep 12h
  certbot renew
done

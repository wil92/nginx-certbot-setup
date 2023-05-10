#!/bin/bash

PATH_CERT="/etc/letsencrypt/live/$DOMAIN"
NEW_CERT_FLAG="/etc/letsencrypt/certbot.flag"

if ! [ -f "$NEW_CERT_FLAG" ]; then
  echo "Initial cert are going to be created"
  touch $NEW_CERT_FLAG

  RSA_KEY_SIZE=2048

  # generate dummy certificates
  echo "-generate dummy certificates"
  echo "$PATH_CERT/fullchain.pem"
  mkdir -p "$PATH_CERT"
  openssl req -x509 -nodes -newkey rsa:$RSA_KEY_SIZE\
    -days 1\
    -keyout "$PATH_CERT/privkey.pem" \
    -out "$PATH_CERT/fullchain.pem" \
    -subj "/CN=localhost"

  # wait until cert is removed
  echo "-wait until cert is removed"
  while : ; do
    sleep 2s
    if ! [ -f "$PATH_CERT/privkey.pem" ]
    then
      break
    fi
    echo "--waiting for certs to be removed"
  done

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

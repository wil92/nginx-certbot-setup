#!/bin/bash

# this scripts is needed to generate the initial cert for the nginx configuration.

PATH_CERT="/etc/letsencrypt/live/$DOMAIN"
NEW_CERT_FLAG="/etc/letsencrypt/nginx.flag"

echo "$PATH_CERT"

if ! [ -f "$NEW_CERT_FLAG" ]; then
  echo "Initial cert are going to be created"
  touch $NEW_CERT_FLAG

  # wait for certificates to continuing
  echo "-wait for certificates to continuing"
  while : ; do
    sleep 2s
    if [ -f "$PATH_CERT/privkey.pem" ]
    then
      break
    fi
    echo "--waiting for certs"
  done

  # start nginx with dummy certs
  echo "-start nginx with dummy certs"
  nginx
  echo "wait 10s for nginx to start"
  sleep 10s

  # remove the certficates
  echo "-remove the certficates"
  rm -f "$PATH_CERT/fullchain.pem"
  rm -f "$PATH_CERT/privkey.pem"

  # wait for fresh certificates
  echo "-wait for fresh certificates"
  while : ; do
    sleep 2s
    if [ -f "$PATH_CERT/privkey.pem" ]
    then
      break
    fi
  done

  # restart nginx with new certs
  echo "-restart nginx with new certs"
  nginx -s reload;
fi

# restart nginx every 6h in case the certbot update the certs
while : ; do
  sleep 6h
  nginx -s reload
done &

nginx -g "daemon off;"

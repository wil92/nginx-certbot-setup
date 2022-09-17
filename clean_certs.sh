#!/bin/bash

echo "Are you sure that you want to clean the certs: y/N"
read RES

if [ "$RES" = "y" ] || [ "$RES" = "Y" ]; then
  sudo rm -rf certbot-certs/*
  sudo rm -rf certbot-config/*
  echo "All files removed"
fi

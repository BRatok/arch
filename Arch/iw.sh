#!/bin/bash

echo "Connecting to wifi..."
read -p "enter wifi SSID  " wifissid
read -p "enter wifi password  " wifipass

echo "Waiting for WPA"
until iwctl known-networks list | grep -i "$wifissid"; do
   iwctl station wlan1 scan
   sleep 1
   iwctl station wlan1 connect "$wifissid" --passphrase "$wifipass"
   sleep 2
done

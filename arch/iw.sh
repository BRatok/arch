#!/bin/bash

echo "Connecting to wifi..."
iwctl station wlan0 connect Cabal --passphrase ""

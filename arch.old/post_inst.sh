#!/bin/bash

echo "Setting up WiFi connection (first boot)..."

# Ensure WiFi radio is enabled
nmcli radio wifi on

# Force a fresh scan and display available networks
echo "Scanning for available WiFi networks..."
nmcli device wifi rescan
sleep 3  # Give time for the scan to complete

echo "Available WiFi networks:"
nmcli device wifi list

echo ""
echo "Enter the exact SSID (network name) you want to connect to:"
read ssid

if [ -z "$ssid" ]; then
    echo "No SSID entered. Skipping WiFi setup."
else
    echo "Connecting to '$ssid'..."
    echo "You will now be securely prompted for the WiFi password (input will not be visible)."
    nmcli --ask device wifi connect "$ssid"

    if [ $? -eq 0 ]; then
        echo "Successfully connected to '$ssid'! The connection profile has been saved for future boots."
    else
        echo "Failed to connect to '$ssid'. You can try again later by running:"
        echo "  nmcli device wifi list"
        echo "  nmcli device wifi connect <SSID>"
    fi
fi

# (Any other post-install commands you had can go here)

curl -fsS https://dl.brave.com/install.sh | sh


# End of postinstall cleanup
systemctl disable postinstall.service
rm -f /etc/systemd/system/postinstall.service

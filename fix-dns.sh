#!/usr/bin/env bash
set -e

echo "========================================================="
echo " NETWORKWALKS LAB: WK1-PM1 Automated Network Patch"
echo "========================================================="

# 1. Write DNS targets into resolution configuration
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null
echo "[✓] Static DNS configurations populated."

# 2. Apply the official course fix for VirtualBox v7 DAD timeout bugs
echo "Applying VirtualBox v7 / NetworkManager dad-timeout patch..."
sudo nmcli connection modify "Wired connection 1" ipv4.dad-timeout 0
sudo nmcli connection down "Wired connection 1" > /dev/null 2>&1 || true
sudo nmcli connection up "Wired connection 1" > /dev/null 2>&1 || true
echo "[✓] Network connection interface restarted."

echo ""
echo "Verifying external domain resolution..."
echo "---------------------------------------------------------"

if ping -c 3 google.com > /dev/null 2>&1; then
    echo "[✓] Phase 1 Success: Network connection is fully functional!"
else
    echo "[X] Error: Resolution failing. Verify VirtualBox NATNetwork settings."
    exit 1
fi

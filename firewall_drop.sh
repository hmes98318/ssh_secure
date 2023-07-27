#!/bin/bash

# Get the list of IPs from /etc/hosts.deny
IPS_HOSTS_DENY=$(grep "sshd:" /etc/hosts.deny | awk -F: '{print $2}')

# Get the list of IPs from firewall rules
IPS_FIREWALL=$(firewall-cmd --list-all | grep 'source address=' | awk -F'"' '{print $4}')


# Loop through the IPs from /etc/hosts.deny
while IFS= read -r IP; 
do
  # Check if the IP is not in the firewall rules
  if ! echo "$IPS_FIREWALL" | grep -q "$IP"; then
    firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='$IP' drop"
    echo "Added $IP to firewall drop list."
  fi
done <<< "$IPS_HOSTS_DENY"


# Reload the firewall rules to apply changes
firewall-cmd --reload

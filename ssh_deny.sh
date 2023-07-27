#!/bin/bash

basepath=$(cd `dirname $0`; pwd)
logfile=$basepath/black.list


# Check for too many incorrect password entered
echo "INVALID_PASSWORD" > $logfile
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' >> $logfile

# Check for invalid format attacks
echo "INVALID_FORMAT_ATTACK" >> $logfile
grep "banner exchange: Connection from" /var/log/secure | awk '{print $(NF-4)}' | sort | uniq >> "$logfile"


MODE="INVALID_PASSWORD"
MAX_FAILED_LOGIN_ATTEMPTS=2

while IFS= read -r line
do
  # Check for the markers
  if [ "$line" == "INVALID_PASSWORD" ]; then
    MODE="INVALID_PASSWORD"
    continue
  elif [ "$line" == "INVALID_FORMAT_ATTACK" ]; then
    MODE="INVALID_FORMAT_ATTACK"
    continue
  fi

  if [ "$MODE" == "INVALID_PASSWORD" ]; then
    IP=$(echo "$line" | awk -F= '{print $1}')
    NUM=$(echo "$line" | awk -F= '{print $2}')

    if [ "$NUM" -gt $MAX_FAILED_LOGIN_ATTEMPTS ]; then
      grep -q "$IP" /etc/hosts.deny

      if [ $? -ne 0 ]; then
        echo "sshd:$IP:deny" >> /etc/hosts.deny
        echo "Added $IP to /etc/hosts.deny due to too many incorrect password entered."
      fi
    fi
  elif [ "$MODE" == "INVALID_FORMAT_ATTACK" ]; then
    IP=$(echo "$line")
    grep -q "$IP" /etc/hosts.deny

    if [ $? -ne 0 ]; then
      echo "sshd:$IP:deny" >> /etc/hosts.deny
      echo "Added $IP to /etc/hosts.deny due to invalid format attack."
    fi
  fi
done < "$logfile"
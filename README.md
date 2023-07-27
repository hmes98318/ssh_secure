# ssh_secure
**ssh_secure** is a shell script that automatically adds suspicious IP addresses to a blacklist to protect your SSH server from brute-force attacks.


## Compatibility

This script is intended to work on CentOS 7.  
For Rocky Linux 9, additional steps are required to install `tcp_wrappers`.  
Please refer to the following link for guidance: [How to Filter SSH Connections with hosts.allow on Rocky Linux 8](https://zedt.eu/tech/linux/how-to-filter-ssh-connections-with-hosts-allow-on-rocky-linux-8/).


## Usage

1. Clone the repository or download the script to your desired location.
2. Make the script executable: `chmod +x ssh_secure.sh`.
3. Use root privileges to set up a crontab for automating the script.  

Set up the `ssh_deny.sh` script to run every minute. It collects IP addresses from `/var/log/secure` and adds them to the `/etc/hosts.deny` file, effectively blacklisting them.
```bash
* * * * * /root/ssh_secure.sh
```

Set up the `firewall_drop.sh` script to run every five minutes. It retrieves the blacklisted IP addresses from `/etc/hosts.deny` and adds firewall rules to drop incoming traffic from these IPs.
```bash
*/5 * * * * /root/firewall_drop.sh
```

> **Note:** In order for the `firewall_drop.sh` script to work effectively, the `ssh_deny.sh` script must be run periodically to update the `/etc/hosts.deny` file.


## Contributing

Contributions to this project are welcome. If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
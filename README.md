# ssh_secure
**ssh_secure** is a shell script that helps protect your SSH server from brute-force attacks by maintaining a blacklist of IP addresses involved in suspicious activities.

## Compatibility

This script is intended to work on CentOS 7. For Rocky Linux 9, additional steps are required to install `tcp_wrappers`. Please refer to the following link for guidance: [How to Filter SSH Connections with hosts.allow on Rocky Linux 8](https://zedt.eu/tech/linux/how-to-filter-ssh-connections-with-hosts-allow-on-rocky-linux-8/).

## Usage

1. Clone the repository or download the script to your desired location.
2. Make the script executable: `chmod +x ssh_secure.sh`.
3. Use root privileges to set up a crontab for automating the script.  

Schedule the script to run every minute
```bash
* * * * * /root/ssh_secure.sh
```

Optionally, you have the choice to add a firewall_drop script that runs every five minutes to further enhance security. This script helps in blocking malicious IP addresses at the firewall level.
```bash
*/5 * * * * /root/firewall_drop.sh
```

## Contributing

Contributions to this project are welcome. If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
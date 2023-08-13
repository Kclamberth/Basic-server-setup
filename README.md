# Basic server setup
Basic script to automate some initial server settings. 
This is intended for personal use only.

The script installs HTOP, UFW, & Fail2ban and creates a ssh allow rule in the firewall.

It also changes the fail2ban bantime to 120mins, range to 10 mins, and max retries to 2.

If you use this you will have to ensure you LAN is set up in a similar way. 

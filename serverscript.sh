#!/bin/bash

#Welcome Message
echo "Welcome to KCL server setup."
echo "HTOP, UFW, & Fail2ban will be installed and set up on this system."
echo "This script is intended for personal use only."

echo " "
sleep 3

#Update system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y >> /var/log/kcl_sec.log

#Application list
app1=ufw
app2=fail2ban
app3=htop

#Install applications
echo "Installing $app1,$app2, & $app3..."
sudo apt-get install -y $app1 >> /var/log/kcl_sec.log
e1=$?
sudo apt-get install -y $app2 >> /var/log/kcl_sec.log
e2=$?
sudo apt-get install -y $app3 >> /var/log/kcl_sec.log
e3=$?

echo " "
sleep 3

#Modify firewall
echo "Setting up SSH firewall rules..."
sudo ufw allow from 172.16.0.0/24 to any port 22 comment "SSH LAN"
e4=$?
sudo ufw allow from 100.64.0.0/10 to any port 22 comment "SSH VPN"
e5=$?

echo "Starting firewall..."
sudo ufw enable
e6=$?

echo " "

#Modify fail2ban
echo "Creating fail2ban files..."
sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
e7=$?
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
e8=$?

echo "Modifying fail2ban jail file..." 
wget -qO /etc/fail2ban/jail.local "https://raw.githubusercontent.com/Kclamberth/security-script/main/jail.local"  
e9=$?

echo "Starting fail2ban..."
sudo systemctl start fail2ban
e10=$?

echo " "
sleep 3

#Error messages from exit codes
if [ $e1 -ne 0 ]
then
    echo "$app1 failed to install."

elif [ $e2 -ne 0 ]
then
    echo "$app2 failed to install."

elif [ $e3 -ne 0 ]
then
    echo "$app3 failed to install." 

elif [ $e4 -ne 0 ] || [ $e5 -ne 0 ]
then
    echo "Firewall rules incorrectly updated." 
    echo "Check with 'sudo ufw status'."

elif [ $e6 -ne 0 ]
then 
    echo "Firewall failed to start."

elif [ $e7 -ne 0 ] || [ $e8 -ne 0]
then
    echo "/etc/fail2ban/jail.local or /etc/fail2ban/fail2ban.local did not copy correctly."
    echo "Check the /etc/fail2ban directory." 

elif [ $e9 -ne 0 ]
then
    echo "Failed to correctly update the /etc/fail2ban/jail.local file."

#Successful message
else
    echo "Successfully installed HTOP, Uncomplicated Fire Wall(UFW) and Fail2ban." 
    echo "Verify via 'sudo ufw status' and 'sudo systemctl status fail2ban'."


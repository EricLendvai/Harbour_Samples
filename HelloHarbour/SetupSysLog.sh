#!/bin/bash

# The following script is not stable due to "systemd" not working properly.
#  I tried using the previous method to deal with services by using the "service" command. This is not stable as well.

# https://devblogs.microsoft.com/commandline/a-preview-of-wsl-in-the-microsoft-store-is-now-available/#how-to-install-and-use-wsl-in-the-microsoft-store

#depending of the version of WSL and Ubuntu, rsyslog might already be running, or doing a service rsyslog restart would not work.
#service --status-all

#The following seems to not work as well
#  systemctl list-unit-files --type=service

#to view version of Ubuntu
#  cat /proc/version

mkdir /etc/rsyslog.d/
output=/etc/rsyslog.d/harbour.conf
echo "local1.debug -/var/log/harbourapps.log" > $output

echo "Install rsyslog"
apt-get install -y rsyslog

# read -p "Press enter to continue"

# to allow using "service" instead of "systemd"
#echo "Install orphan-sysvinit-scripts"
#apt-get install -y orphan-sysvinit-scripts


# Following is not needed
#echo "Install inetutils-syslogd"
#apt-get install -y inetutils-syslogd

#create in case is missing, to allow the tail command to work
touch /var/log/harbourapps.log

#service rsyslog restart

#depending if the /etc/rsyslog.d/harbour.conf work or not, message are written in syslog or harbourapps.log
#tail -f -n20 /var/log/syslog
#tail -f -n20 /var/log/harbourapps.log

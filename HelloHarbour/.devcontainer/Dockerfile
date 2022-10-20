FROM ericlendvai/harbour-simple:latest
# See file Harbour_Samples\Docker\harbour_basic\Dockerfile to view how this harbour_basic docker image was created.

RUN echo "Using Harbour-simple:latest as base"

# The following instructions are needed under WSL (Windows Subsystem for Linux) with Ubuntu 20.04 distro

# Instructions for starting syslog (rsyslog) and send the syslog messages to /var/log/harbourapps.log
RUN apt-get install -y rsyslog

# As per https://stackoverflow.com/questions/56609182/openthread-environment-docker-rsyslogd-imklog-cannot-open-kernel-log-proc-km
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

# To ensure future tail command will work even before any message are added.
RUN touch /var/log/harbourapps.log
RUN chmod ugo+rwx /var/log/harbourapps.log

# Having a separate .conf file does not work. Appending the the main config file seems to make it work.
RUN echo "local1.debug -/var/log/harbourapps.log" >> /etc/rsyslog.conf

# To use the "service" instead of "systemd"
RUN apt-get install -y orphan-sysvinit-scripts

# Command to use the last 50 message from syslog calls
# $tail -f -n50 /var/log/harbourapps.log

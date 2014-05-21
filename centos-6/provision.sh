#!/bin/bash -xe

# Install many common packages.
# rsync and openssh-clients are needed for Vagrant.
yum install -y initscripts postfix rsyslog sudo zip tar redhat-lsb-core rsync openssh-clients wget curl openssh-server unzip

# Set up some things to make /sbin/init and udev work (or not start as appropriate.)

# https://github.com/dotcloud/docker/issues/1240#issuecomment-21807183
echo "NETWORKING=yes" > /etc/sysconfig/network

# http://gaijin-nippon.blogspot.com/2013/07/audit-on-lxc-host.html
sed -i -e '/pam_loginuid\.so/ d' /etc/pam.d/sshd

# Kill udev. (http://serverfault.com/a/580504/82874)
echo " " > /sbin/start_udev

# No more requiretty for sudo. (Vagrant likes to run Puppet/shell via sudo.)
sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers

# Let this run as an unmodified Vagrant box.
groupadd vagrant
useradd vagrant -g vagrant -G wheel
echo "vagrant:vagrant" | chpasswd
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built Docker container.' > /etc/motd

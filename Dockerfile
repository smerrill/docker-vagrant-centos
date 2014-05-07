FROM centos

# Install many common packages.
# rsync and openssh-clients are needed for Vagrant.
RUN yum install -y initscripts postfix rsyslog sudo zip tar redhat-lsb-core rsync openssh-clients wget curl openssh-server unzip

# Set up some things to make /sbin/init and udev work (or not start as appropriate.)

# https://github.com/dotcloud/docker/issues/1240#issuecomment-21807183
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# http://gaijin-nippon.blogspot.com/2013/07/audit-on-lxc-host.html
RUN sed -i -e '/pam_loginuid\.so/ d' /etc/pam.d/sshd

# Kill udev. (http://serverfault.com/a/580504/82874)
RUN echo " " > /sbin/start_udev

# No more requiretty for sudo. (Vagrant likes to run Puppet/shell via sudo.)
RUN sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers

# Let this run as an unmodified Vagrant box.
RUN groupadd vagrant
RUN useradd vagrant -g vagrant -G wheel
RUN echo "vagrant:vagrant" | chpasswd
RUN echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/vagrant
RUN chmod 0440 /etc/sudoers.d/vagrant

# Installing vagrant keys
RUN mkdir -pm 700 /home/vagrant/.ssh
RUN wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
RUN chmod 0600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant /home/vagrant/.ssh

# Customize the message of the day
RUN echo 'Welcome to your Vagrant-built Docker container.' > /etc/motd

EXPOSE 22
CMD /sbin/init


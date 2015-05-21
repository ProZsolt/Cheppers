#!/bin/bash

apt-get update -y
apt-get upgrade -y
ntpdate pool.ntp.org
apt-get -y install ntp
service ntp restart
cd /tmp
wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update -y
apt-get -y install puppet
puppet module install puppetlabs-apache
puppet module install puppetlabs-mysql
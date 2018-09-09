#!/usr/bin/env bash
yum install dhcp -y
yum install wget -y
cp /vagrant/scripts/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd

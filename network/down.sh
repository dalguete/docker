#!/bin/sh

# Remove the dnsmasq control file 
rm /etc/dnsmasq.d/$1.docker

# dnsmasq service must be restarted
service dnsmasq restart


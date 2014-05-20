#!/bin/sh

# The container id is passed as the first item in the call ($1)

# Get the starting container IP
docker inspect --format='{{.NetworkSettings.IPAddress}}' $1 > /tmp/$1.ip

# Get the starting container hostname
docker inspect --format='{{.Config.Hostname}}' $1 > /tmp/$1.hostname

# Create a file under dnsmasq control so host can access container via name
# NOTE: $() and `` do the same. I just used them both, in my intention to be cool :)
echo "address=/$(cat /tmp/$1.hostname).docker/`cat /tmp/$1.ip`" > /etc/dnsmasq.d/$1.docker

# Remove files used
rm /tmp/$1.ip
rm /tmp/$1.hostname

# dnsmasq service must be restarted
service dnsmasq restart


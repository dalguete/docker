#!/bin/sh

# Remove the dnsmasq control file 
rm /etc/dnsmasq.d/$1.docker

# Initially I was going to restart dnsmasq service, but it ended with some errors
# in the container creation, and no container at the end.
# Interestingly the service restart was not needed, as dnsmasq read the file as 
# soon as it got created (maybe docker did something in back, maybe dnsmasq is more 
# awesome than I thought, maybe just lucky, but it works)
#
#service dnsmasq service

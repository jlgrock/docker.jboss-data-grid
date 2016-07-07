#!/bin/sh

# Load the current versions
. ./loadenv.sh

# set the host ip for eth0 - this may not scale well
HOST_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo "HOST IP: $HOST_IP"

INFINISPAN_VERSION=
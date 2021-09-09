#!/usr/bin/with-contenv bashio

echo Hello world!
cat /etc/squid/squid.conf
echo /etc/squid
ls /etc/squid
squid -d 2
# rc-service squid start
sleep infinity
#!/bin/bash

netPrefix=$1
dnsResolver=$2

for host in $(seq 1 254); do
    nslookup $netPrefix.$host $dnsResolver | grep "name"
done

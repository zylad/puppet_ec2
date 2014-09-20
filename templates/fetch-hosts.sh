#!/bin/bash
# Fetch hosts file for this instance 
aws s3 cp s3://adroll-releases/etc_hosts/etc_hosts.<%=ec2_hosts_file %>.sh /tmp/hosts.sh
. /tmp/hosts.sh
echo "<%=serverip %> puppet" >> /etc/hosts

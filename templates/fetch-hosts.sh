#!/bin/bash
# Fetch hosts file for this instance 
aws s3 cp s3://adroll-releases/etc_hosts/etc_hosts.<%=ec2_region %>.sh /tmp/
. /tmp/etc_hosts.<%=ec2_region %>.sh
echo "<%=serverip %> puppet" >> /etc/hosts

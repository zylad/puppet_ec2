# Puppet EC2 Facts
Puppet includes some nice support for EC2 metadata, but both it and
Chef seem unable to include these facts when the instance is running in
a VPC.

To this end, a Facter script for these metadata entries is included
here, along with scripts to easily determine which tags and EBS volumes
are attached to the instance.

This module is tested on Puppet 3.6 running under Ruby 2.0 (installed
on Amazon Linux) - I cannot make guarantees on it working on other
platforms.

## Retrieves basic instance information from the metadata service.
require 'net/http'


Facter.add('ec2_ami_id') {
  setcode { Net::HTTP.get('169.254.169.254', 'latest/meta-data/ami-id') }
}

Facter.add('ec2_instance_id') {
  setcode { Net::HTTP.get('169.254.169.254', 'latest/meta-data/instance-id') }
}

Facter.add('ec2_az') {
  setcode { Net::HTTP.get('169.254.169.254', 'latest/meta-data/placement/availability-zone') }
}

Facter.add('ec2_region') {
  setcode { Facter.value('ec2_az').chop }
}

Facter.add('ec2_instance_type') {
  setcode { Net::HTTP.get('169.254.169.254', 'latest/meta-data/instance-type') }
}

Facter.add('ec2_public_ip') {
  setcode { Net::HTTP.get('169.254.169.254', 'latest/meta-data/public-ipv4') }
}


## This section will pull the VPC ID this instance is in.
require 'aws-sdk'

region      = Facter.value('ec2_region')
instance_id = Facter.value('ec2_instance_id')

AWS.config(region: region)

Facter.add('ec2_vpc_id') {
  setcode { AWS.ec2.instances[instance_id].vpc_id }
}

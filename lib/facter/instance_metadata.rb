## Retrieves basic instance information from the metadata service.
require 'net/http'
require 'aws-sdk'

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
Facter.add('ec2_mac') {
  setcode { Net::HTTP.get('169.254.169.254', 'latest/meta-data/mac') }
}

Facter.add('ec2_vpc_id') {
  setcode {
    mac   = Facter.value('ec2_mac')
    resp  = Net::HTTP.get_response('169.254.169.254',
      "latest/meta-data/network/interfaces/macs/#{mac}/vpc-id")

    if resp.code == '200' then
      resp.body
    end
  }
}

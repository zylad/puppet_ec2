# Fetch what the hosts file for this region should be called.
Facter.add('ec2_hosts_file') {
  setcode {
    region  = Facter.value('ec2_region')
    vpc     = Facter.value('ec2_vpc_id')

    if vpc != nil then
      region = "#{region}.#{vpc}"
    end

    region
  }
}

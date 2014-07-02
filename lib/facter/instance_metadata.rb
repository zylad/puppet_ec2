## Retrieves basic instance information from the metadata service.
require 'json'

Facter.add("ec2_ami") do
  setcode do
    Facter::Util::Resolution.exec("curl -sL http://169.254.169.254/latest/meta-data/ami-id")
  end
end

Facter.add("ec2_instance_id") do
  setcode do
    Facter::Util::Resolution.exec("curl -sL http://169.254.169.254/latest/meta-data/instance-id")
  end
end

Facter.add("ec2_az") do
  setcode do
    Facter::Util::Resolution.exec("curl -sL http://169.254.169.254/latest/meta-data/placement/availability-zone")
  end
end

Facter.add("ec2_region") do
  setcode do
    Facter::Util::Resolution.exec("curl -sL http://169.254.169.254/latest/meta-data/placement/availability-zone").chop
  end
end

Facter.add("ec2_instance_type") do
  setcode do
    Facter::Util::Resolution.exec("curl -sL http://169.254.169.254/latest/meta-data/instance-type")
  end
end

Facter.add("ec2_public_ip") do
  setcode do
    Facter::Util::Resolution.exec("curl -sL http://169.254.169.254/latest/meta-data/public-ipv4")
  end
end

region = Facter.value('ec2_region')
instance_id = Facter.value('ec2_instance_id')

instance_data_output = Facter::Util::Resolution.exec("aws ec2 describe-instances --region #{region} --filters 'Name=instance-id,Values=#{instance_id}'")
instance_data = JSON.parse(instance_data_output)

Facter.add("ec2_vpc_id") do
  setcode do
    instance_data["Reservations"][0]["Instances"][0]["VpcId"]
  end
end

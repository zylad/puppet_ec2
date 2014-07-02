## Gather up EC2 tags for this instance.
require 'json'

region = Facter.value('ec2_region')
instance_id = Facter.value('ec2_instance_id')

tags_output = Facter::Util::Resolution.exec("aws ec2 describe-tags --region #{region} --filters 'Name=resource-id,Values=#{instance_id}'")
tags = JSON.parse(tags_output)

tags["Tags"].each do |tag|
  clean_key = tag["Key"].gsub(/\W+/, "_")

  Facter.add("ec2_tag_#{clean_key}") do
    setcode do
      tag['Value']
    end
  end
end

## Gather up EC2 tags for this instance.
require 'aws-sdk'

region      = Facter.value('ec2_region')
instance_id = Facter.value('ec2_instance_id')
clean_tags  = {}

AWS.config(region: region)
instance    = AWS.ec2.instances[instance_id]

instance.tags.each { |k, v|
  clean_key = k.gsub(/\W+/, "_")

  Facter.add("ec2_tag_#{clean_key}") {
    setcode { v }
  }

  clean_tags[clean_key] = v
}

Facter.add('ec2_tags') {
    setcode { clean_tags }
}

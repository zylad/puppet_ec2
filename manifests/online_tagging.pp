## Class ec2::online_tagging
##
## Notes that an EC2 instance is online and ready to serve requests.
##
class ec2::online_tagging {

  ec2::tag { 'online':
    ensure => 'true',
  }

  ec2::tag { 'dns':
  	ensure => $::hostname,
  }

}
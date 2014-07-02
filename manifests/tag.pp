## Type ec2::tag
##
## Ensures that an EC2 tag is on an instance.
## Port this to Ruby when you get a chance.
define ec2::tag(
  $ensure,
  $tagname = $title
) {

  exec { "add tag ${tagname} to instance":
    command => template('ec2/tag_add_command.sh'),
    unless  => template('ec2/tag_check_command.sh'),
  }

}
## Gathers information about the EBS drives attached to this instance.
require 'aws-sdk'

region            = Facter.value('ec2_region')
instance_id       = Facter.value('ec2_instance_id')

total_volumes     = []
non_root_volumes  = []

AWS.config(region: region)

resp = AWS.ec2.client.describe_volumes(filters: [{name: 'attachment.instance-id', values: [instance_id]}])

resp.data()[:volume_set].each { |vol|
  clean_drive_name  = vol[:volume_id].gsub(/-/, "_")
  attachment        = vol[:attachment_set][0]

  total_volumes << clean_drive_name

  Facter.add("ec2_ebs_#{clean_drive_name}_size_gb") {
    setcode { vol[:size] }
  }

  ## If we have a snapshot ID to go along with this drive, include
  ## it for consumption by other systems.
  Facter.add("ec2_ebs_#{clean_drive_name}_snapshot_id") {
    setcode { vol[:snapshot_id] }
  }

  ## Determine what kind of EBS drive this is.
  Facter.add("ec2_ebs_#{clean_drive_name}_type") {
    setcode { vol[:volume_type] }
  }

  if vol["VolumeType"] == "io1" then
    Facter.add("ec2_ebs_#{clean_drive_name}_iops") {
      setcode { vol[:iops] }
    }
  end

  Facter.add("ec2_ebs_#{clean_drive_name}_mount_point") {
    setcode { attachment[:device].gsub(/s/, 'xv') }
  }

  ## We want to mark the root EBS drive as special.
  if Facter.value("ec2_ebs_#{clean_drive_name}_mount_point") == '/dev/xvda1' then
    Facter.add("ec2_ebs_#{clean_drive_name}_is_root_device") {
      setcode { true }
    }
  else
    non_root_volumes << clean_drive_name
  end

  Facter.add("ec2_ebs_#{clean_drive_name}_delete_on_termination") {
    setcode { attachment[:delete_on_termination] }
  }
}

Facter.add("ec2_ebs_volumes") {
  setcode { total_volumes }
}

Facter.add("ec2_ebs_non_root_volumes") {
  setcode { non_root_volumes }
}

## Gathers information about the EBS drives attached to this instance.
require 'aws-sdk'

ebs_drive_data    = {}
total_volumes     = []
non_root_volumes  = []

Facter.add('ec2_ebs_drive_data') {
  setcode {
  	region            = Facter.value('ec2_region')
  	instance_id       = Facter.value('ec2_instance_id')
  
  	AWS.config(region: region)
  
  	resp = AWS.ec2.client.describe_volumes(filters: [{name: 'attachment.instance-id', values: [instance_id]}])
  
  	resp.data()[:volume_set].each { |vol|
  	  volume_id         = vol[:volume_id]
  	  attachment        = vol[:attachment_set][0]
  	  drive             = {}
  
  	  total_volumes << volume_id
  
  	  drive['size_gb'] = vol[:size]
  
  	  ## If we have a snapshot ID to go along with this drive, include
  	  ## it for consumption by other systems.
  	  drive['snapshot_id'] = vol[:snapshot_id]
  
  	  ## Determine what kind of EBS drive this is.
  	  drive['type'] = vol[:volume_type]
  
  	  if drive['type'] == 'io1' then
  	    drive['iops'] = vol[:iops]
  	  end
  
  	  drive['mount_point'] = attachment[:device].gsub(/s/, 'xv')
  
  	  ## We want to mark the root EBS drive as special.
  	  if drive['mount_point'] == '/dev/xvda1' then
  	    drive['is_root_device'] = true
  	  else
  	    non_root_volumes << volume_id
  	  end
  
  	  drive['delete_on_termination'] = attachment[:delete_on_termination]
  
  	  ## Iterate through the tags and create a better data representation.
  	  volume_tags = {}
  	  vol[:tag_set].each { |tag|
  	    volume_tags[tag[:key]] = tag[:value]
  	  }
  
  	  drive['tags'] = volume_tags
  	  ebs_drive_data[volume_id] = drive
  	}
  
  	ebs_drive_data
  }
}

Facter.add("ec2_ebs_volumes") {
  setcode { total_volumes }
}

Facter.add("ec2_ebs_non_root_volumes") {
  setcode { non_root_volumes }
}

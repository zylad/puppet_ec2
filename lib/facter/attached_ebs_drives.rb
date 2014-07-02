## Gathers information about the EBS drives attached to this instance.
require 'json'

total_volumes = []
non_root_volumes = []

region = Facter.value('ec2_region')
instance_id = Facter.value('ec2_instance_id')

volumes_output = Facter::Util::Resolution.exec("aws ec2 describe-volumes --region #{region} --filters 'Name=attachment.instance-id,Values=#{instance_id}'")
volumes = JSON.parse(volumes_output)

volumes["Volumes"].each do |vol|
  clean_drive_name = vol["VolumeId"].gsub(/-/, "_")
  total_volumes << clean_drive_name

  Facter.add("ec2_ebs_#{clean_drive_name}_size_gb") do
    setcode do
      vol["Size"]
    end
  end

  ## If we have a snapshot ID to go along with this drive, include
  ## it for consumption by other systems.
  if !vol["SnapshotId"].nil?
    Facter.add("ec2_ebs_#{clean_drive_name}_snapshot_id") do
      setcode do
        vol["SnapshotId"]
      end
    end
  end

  ## Determine what kind of EBS drive this is.
  Facter.add("ec2_ebs_#{clean_drive_name}_type") do
    setcode do
      vol["VolumeType"]
    end
  end

  if vol["VolumeType"] == "io1"
    Facter.add("ec2_ebs_#{clean_drive_name}_iops") do
      setcode do
        vol["Iops"]
      end
    end
  end

  Facter.add("ec2_ebs_#{clean_drive_name}_mount_point") do
    setcode do
      vol["Attachments"][0]["Device"].gsub(/s/, 'xv')
    end
  end

  ## We want to mark the root EBS drive as special.
  if vol["Attachments"][0]["Device"] == "/dev/sda1"
    Facter.add("ec2_ebs_#{clean_drive_name}_is_root_device") do
      setcode do
        true
      end
    end
  else
    non_root_volumes << clean_drive_name
  end

  Facter.add("ec2_ebs_#{clean_drive_name}_delete_on_termination") do
    setcode do
      vol["Attachments"][0]["DeleteOnTermination"]
    end
  end
end

Facter.add("ec2_ebs_volumes") do
  setcode do
    total_volumes.join(",")
  end
end

Facter.add("ec2_ebs_non_root_volumes") do
  setcode do
    non_root_volumes.join(",")
  end
end

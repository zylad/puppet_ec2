## AdRoll's EC2 Hosts file setup.
## Not recommended for external use.
class ec2::hosts {
  file { '/usr/local/bin/fetch-hosts':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => "0755",
    content => template('ec2/fetch-hosts.sh'),
  }

  cron { 'fetch_ec2_hosts':
    ensure  => present,
    command => '/usr/local/bin/fetch-hosts >/dev/null 2>&1',
    user    => root,
    minute  => '*/5',
  }
}

class apache {
  package { 'apache2':
    ensure => installed,
  }

  service { 'apache2':
    ensure => running,
    enable => true,
  }
}

class { 'apache': }

exec { 'strace_apache':
  command => 'strace -p $(pgrep apache2)',
  path    => '/bin:/usr/bin',
  logoutput => true,
  subscribe => Class['apache'],
}

# Add any additional resources or configurations to fix the issue



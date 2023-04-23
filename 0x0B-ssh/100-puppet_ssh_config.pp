# configure ssh config file
file_line { 'disable passwd auth':
  ensure => 'present',
  path   => '/etc/ssh/ssh_config',
  line   => '	PasswordAuthentication no',
  match  => 'PasswordAuthentication yes',
}
file_line {'add school identity file':
  ensure => 'present',
  path   => '/etc/ssh/ssh_config',
  line   => '	IdentityFile ~/.ssh/school',
}

$mysql_password = 'secret'

# install apache
class { 'apache':
  default_vhost => false,
  default_mods => false,
  mpm_module => 'prefork',
}

# creating vhost
apache::vhost { 'hellodrupal.com':
  port    => '80',
  docroot => '/var/www/drupal',
}

# install php
include apache::mod::php

# install mysql server
class { 'mysql::server':
  root_password           => $mysql_password,
  remove_default_accounts => true,
}

# install Drupal
drupal::site { 'HelloDrupal':
  password => 'secret',
  dbname => 'hellodrupal',
}
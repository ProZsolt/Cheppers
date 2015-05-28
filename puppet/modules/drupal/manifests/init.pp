class drupal {

  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }
  
  # install drush  package
  package { 'drush':
    require => Exec['apt-update'],
    ensure => installed,
  }
  
  # install php-gd  package
  package { 'php5-gd':
    require => Exec['apt-update'],
    ensure => installed,
  }
  
  # downloading drupal
  exec { 'install-drupal':
    cwd => '/var/www',
    command => '/usr/bin/drush -y dl drupal --destination=/var/www --drupal-project-rename=drupal',
    require => [ Package['drush'],
                 Class['apache']
               ],
    logoutput => on_failure,
  }
  
  # install drupal site
  define site( $password, $dbname) {
    include drupal
    
    # creating database for Drupal
    mysql::db { $dbname:
      user     => $dbname,
      password => $password,
      host     => 'localhost',
    }
    
    # install Drupal site
    exec { "site-install-${name}":
      cwd => "/var/www/drupal",
      command => "/usr/bin/drush -y -r /var/www/drupal site-install standard --site-name=${name} --db-url=mysql://${dbname}:${password}@localhost/${dbname} --account-name=admin --account-pass=${password}",
      require => [ Exec['install-drupal'],
                   Package['php5-gd'],
                   Mysql::Db[$dbname] 
                 ],
      logoutput => on_failure,
    }
   }
 
}
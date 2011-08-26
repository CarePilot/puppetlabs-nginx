# Class: nginx::package::debian
#
# This module manages NGINX package installation on debian based systems
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::package::debian {
  package { 'nginx':
    ensure => present,
  }
  file { '/etc/nginx/fastcgi_params':
    ensure => present,
    source => "puppet:///modules/nginx/files/fastcgi_params",
    owner  => root,
    group  => root,
    mode   => 0644,
    notify => Service['nginx'],
  }
}

# Class: nginx::package
#
# This module manages NGINX package installation
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
class nginx::package {
  file { 'nginx backports':
    path => '/etc/apt/preferences.d/nginx',
    ensure => present,
    content => "Package: nginx-full nginx-common
Pin: release a=squeeze-backports
Pin-Priority: 600
    ",
    notify => Exec['apt-get update'],
  }

  package { 'nginx-full':
    ensure => present,
    require => File['nginx backports'],
  }

}

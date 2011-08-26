# Class: nginx::service
#
# This module manages NGINX service management and vhost rebuild
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
class nginx::service {
  service { "nginx":
    ensure     => running,
    enable	   => true,
    hasstatus  => true,
    hasrestart => true,
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

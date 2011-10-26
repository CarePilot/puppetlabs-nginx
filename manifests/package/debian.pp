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
  file { '/etc/apt/preferences.d/nginx':
    ensure => present,
    content => "Package: nginx-full
Pin: release a=squeeze-backports
Pin-Priority: 600
    ",
  }

  package { 'nginx-light':
    ensure => absent,
  }
  package { 'nginx-full':
    ensure => present,
  }

  $geo_root = '/etc/nginx/geoip'
  file { $geo_root:
    ensure => directory,
  }
  exec { 'geoip':
    command => "wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && gunzip GeoIP.dat.gz",
    cwd => $geo_root,
    creates => "${geo_root}/GeoIP.dat",
    require => File[$geo_root],
  }
  exec { 'geoiplite':
    command => "wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && gunzip GeoLiteCity.dat.gz",
    cwd => $geo_root,
    creates => "${geo_root}/GeoLiteCity.dat",
    require => File[$geo_root],
  }

  file { "${geo_root}/GeoIP.dat":
    ensure => present,
    owner  => 'www-data',
    group  => 'www-data',
    require => Exec['geoip'],
  }
  file { "${geo_root}/GeoLiteCity.dat":
    ensure => present,
    owner  => 'www-data',
    group  => 'www-data',
    require => Exec['geoiplite'],
  }

}

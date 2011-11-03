class nginx::config inherits nginx::params {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['nginx::package'],
  }

  file { "${nginx::params::nx_conf_dir}":
    ensure => directory,
  }

  file { "${nginx::params::nx_conf_dir}/conf.d":
    ensure => directory,
  }

  file { "${nginx::config::nx_run_dir}":
    ensure => directory,
  }

  file { "${nginx::config::nx_client_body_temp_path}":
    ensure => directory,
    owner  => $nginx::params::nx_daemon_user,
  }

  file { "${nginx::params::nx_conf_dir}/nginx.conf":
    ensure  => file,
    content => template('nginx/conf.d/nginx.conf.erb'),
  }

  file { "${nginx::config::nx_temp_dir}/nginx.d":
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

  file { "${nx_conf_dir}/fastcgi_params":
    ensure => present,
    source => "puppet:///modules/nginx/fastcgi_params",
    notify => Class['nginx::service'],
  }

  file { $nx_geo_root:
    ensure => directory,
  }

  exec { 'geoip':
    command => "wget -o GeoIP.dat.gz 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz' && gunzip -f GeoIP.dat.gz",
    cwd => $nx_geo_root,
    creates => "${nx_geo_root}/GeoIP.dat",
    require => File[$nx_geo_root],
  }
  exec { 'geoiplite':
    command => "wget -o GeoLiteCity.dat.gz 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz' && gunzip -f GeoLiteCity.dat.gz",
    cwd => $nx_geo_root,
    creates => "${nx_geo_root}/GeoLiteCity.dat",
    require => File[$nx_geo_root],
  }

}

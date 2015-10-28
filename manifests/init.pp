# Class: phplint
#
# This class installs PHPLint
#
# Parameters:
#
#  version: (default 2.1_20150305)
#    Determine which version to download
#
#  source: 
#    URL to download from official mirror
#
# Actions:
#   - Install PHPLint
#
# Sample Usage:
#
#  For a standard installation, use:
#
#    class { 'phplint': }
#
class phplint (
  $version = '2.1_20150305',
  $source = 'http://www.icosaedro.it/phplint'
){
  exec { 'get-phplint':
    path    => '/bin:/usr/bin',
    command => "wget ${source}/phplint-${version}.tar.gz",
    cwd     => '/tmp',
    creates => "/tmp/phplint-${version}.tar.gz",
    timeout => 10000,
    onlyif  => "test ! -d /usr/local/phplint-${version}",
  }

  exec { 'untar-phplint':
    path    => '/bin:/usr/bin',
    command => "tar -zxf /tmp/phplint-${version}.tar.gz",
    cwd     => '/usr/local',
    creates => "/usr/local/phplint-${version}",
    timeout => 10000,
    require => Exec['get-phplint'],
  }

  file { "/usr/local/phplint-${version}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    recurse => true,
    require => Exec['untar-phplint'],
  }

  file { '/usr/local/phplint':
    ensure  => 'link',
    owner   => 'root',
    group   => 'root',
    target  => "/usr/local/phplint-${version}",
    require => Exec['untar-phplint'],
  }

  file { '/etc/profile.d/phplint.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/phplint/phplint.txt',
  }

}
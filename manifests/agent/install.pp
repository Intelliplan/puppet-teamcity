# A class for installing the agent from a TeamCity Server
#
class teamcity::agent::install {
  include wget

  wget::fetch { 'download':
    source             => "${teamcity::agent::public_server_url}/update/buildAgent.zip",
    destination        => '/tmp/buildAgent.zip',
    timeout            => 0,
    nocheckcertificate => true,
    verbose            => false,
  }

  exec { 'unzip':
    command => "/usr/bin/unzip buildAgent.zip -d ${teamcity::agent::home}",
    cwd     => '/tmp',
    creates => $teamcity::agent::home,
    require => [
      User[$teamcity::agent::user],
      Wget::Fetch['download']
    ],
    user    => 'root',
  }

  file { $teamcity::agent::home:
    ensure  => directory,
    owner   => $teamcity::agent::user,
    group   => $teamcity::common::group,
    mode    => '0644',
    replace => false,
    require => Exec['unzip'],
  }
}

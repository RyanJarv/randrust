# @summary
#   This class handles the configuration file.
#
# @param config_epp
#   Specifies an absolute or relative file path to an EPP template for the config file. Example value: 'randrust/randrust.epp'.
#
# @param listen_port
#   Specifies the listen port for randrust to serve traffic from
#
# @param interface
#   Specifies the interface to listen on. Default: '0.0.0.0'.
#
class randrust::config (
  Optional[String] $config_epp,
  Optional[String] $interface,
  Optional[Integer[0, 65535]] $listen_port,
) {
  # If config_epp is defined use that, otherwise use our default template.
  if $config_epp {
    $config_content = epp($config_epp)
  } else {
    $config_content = epp('randrust/randrust.epp')
  }

  file { '/etc/default/randrust':
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => $config_content,
  }

  # if $randrust::logfile {
  #   file { $randrust::logfile:
  #     ensure => file,
  #     owner  => 'randrust',
  #     group  => 'randrust',
  #     mode   => '0664',
  #   }
  # }
}

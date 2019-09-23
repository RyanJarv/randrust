# @summary
#   This class handles the randrust service.
#
# @param package_ensure
#   Whether to install the randrust package, and what version to install. Values: 'present', 'latest', or a specific version number.
#   Default value: 'present'.
#
# @param service_manage
#   Whether to manage the randrust service.  Default value: true.
#
# @param service_enable
#   Whether to enable the randrust service at boot. Default value: true.
#
# @param service_ensure
#   Whether the randrust service should be running. Default value: 'running'.
#
# @param service_provider
#   Which service provider to use for randrust. Default value: 'undef'.
#
# @param service_name
#   The name of the randrust service to manage.
#
class randrust::service (
  Boolean $service_manage,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  Optional[String] $service_provider,
  String $service_name,
) {
  if $service_manage == true {
    service { 'randrust':
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $service_name,
      provider   => $service_provider,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}

# @summary A short summary of the purpose of this class
#   This class handles the randrust package.
#
# @example
#   include randrust::install
#
# @param package_name
#   Specifies the randrust package to manage. Default value: ['randrust'].
#
# @param package_manage
#   Whether to manage the randrust package. Default value: true.
#
# @param package_ensure
#   Whether to install the randrust package, and what version to install. Values: 'present', 'latest', or a specific version number.
#   Default value: 'present'.
#
class randrust::install (
  String $package_ensure,
  Boolean $package_manage,
  Array[String] $package_name,
) {
  if $package_manage {

    packagecloud::repo { 'jarv/test':
      type => 'deb',
    }

    package { $package_name:
      ensure => $package_ensure,
    }

  }
}

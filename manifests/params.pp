# Class: apparmor::params
#
# This class defines default parameters used by the main module class apparmor
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to apparmor class for the variables defined here.
#

class apparmor::params {

  $mode = $::operatingsystem ? {
    default => 'disable',
  }
  $apparmor_dir = $::operatingsystem ? {
    default => '/etc/apparmor.d',
  }
  $profile = $::operatingsystem ? {
    default => '*',
  }

  case $::osfamily
  {
    'Redhat':
    {
      fail('This is my sandbox, I\'m not allowed to go in the deep end - Ralph Wiggum')
    }
    'Debian':
    {
      $packages = [ 'apparmor-utils' ]
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^1[468].*/: { }
            /^20.*/: { }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::lsbdistcodename {
            /buster|bullseye|bookworm/: { }
            default: {
              fail("Unsupported Debian release: '${::lsbdistcodename}'")
            }
          }
          default: { fail('Unsupported Debian flavour!')  }
        }
        'Suse':
        {
          $packages = [ 'apparmor-utils', 'apparmor-parser' ]
          case $::operatingsystem {
            'SLES':
            {
              case $::operatingsystemrelease
              {
                '11.3':
                {
                  $default_mode='complain'
                }
                /^12.[34]/:
                {
                  $default_mode='complain'
                }
                default: { fail("Unsupported SLES version ${::operatingsystem} ${::operatingsystemrelease}") }
              }
            }
            default: { fail("Unsupported operating system ${::operatingsystem}") }
          }
        }
        default: { fail('Unsupported OS!')  }
      }
    }
  }
}

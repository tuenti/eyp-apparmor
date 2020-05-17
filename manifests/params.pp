class apparmor::params {

  case $::osfamily
  {
    'redhat':
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
            /^1[468].*/:
            {
              $apparmor_dir = '/etc/apparmor.d'
              $default_mode='disable'
            }
            /^20.*/:
            {
              $apparmor_dir = '/etc/apparmor.d'
              $default_mode='disable'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            /^10.*/:
            {
              $apparmor_dir = '/etc/apparmor.d'
              $default_mode='disable'
            }
            default: { fail("Unsupported Debian version! - ${::operatingsystemrelease}")  }
          }
        }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    'Suse':
    {
      $packages = [ 'apparmor-utils', 'apparmor-parser' ]
      case $::operatingsystem
      {
        'SLES':
        {
          case $::operatingsystemrelease
          {
            '11.3':
            {
              $apparmor_dir = '/etc/apparmor.d'
              $default_mode='complain'
            }
            /^12.[34]/:
            {
              $apparmor_dir = '/etc/apparmor.d'
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

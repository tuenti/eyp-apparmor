class apparmor(
                $mode    = $apparmor::params::default_mode
                $profile = $apparmor::params::default_profile
              ) inherits apparmor::params {

  if ! $mode in  [ 'complain', 'enforce', 'disable' ] {
    fail('Invalid apparmor operation mode')
  }

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  package { $apparmor::params::packages:
    ensure => 'installed',
  }

  case $mode
  {
    'disable':
    {
      case $::eyp_apparmor_current_status
      {
        'disabled': {}
        default:
        {
          if($::osfamily=='SuSE')
          {
            fail('Unsupported mode on SuSE, please use complain instead')
          }

          exec { 'set apparmor enforce':
            command => "aa-enforce ${apparmor::params::apparmor_dir}/${profile}; exit 0",
            require => Package['apparmor-utils'],
            unless  => 'apparmor_status | grep -E \'0 profiles are loaded.\$\'',
          }

          exec { "set apparmor ${mode}":
            command => "aa-${mode} ${apparmor::params::apparmor_dir}/${profile}",
            #command => "bash -c 'for i in $(find ${apparmor::params::apparmor_dir} -maxdepth 1 -type f); do aa-${mode} \$i; done; exit 0'",
            require => Exec['set apparmor enforce'],
            unless  => 'apparmor_status | grep -E \'0 profiles are loaded.\$\'',
          }
        }
      }
    }
    'complain':
    {
      case $::eyp_apparmor_current_status
      {
        'disabled':
        {
          exec { 'set apparmor enforce':
            command => "aa-enforce ${apparmor::params::apparmor_dir}/${profile}",
            require => Package['apparmor-utils'],
          }

          exec { "set apparmor ${mode}":
            command => "aa-${mode} ${apparmor::params::apparmor_dir}/${profile}",
            require => Exec['set apparmor enforce'],
            onlyif  => "apparmor_status | grep -vE '0 profiles are loaded.\$' | grep -E ' profiles are loaded.\$| profiles are in ${mode} mode.\$' | awk '{ print \$1 }' | uniq | wc -l | grep 2",
          }
        }
        default:
        {
          exec { "set apparmor ${mode}":
            command => "aa-${mode} ${apparmor::params::apparmor_dir}/${profile}",
            require => Package['apparmor-utils'],
            onlyif  => "apparmor_status | grep -vE '0 profiles are loaded.\$' | grep -E ' profiles are loaded.\$| profiles are in ${mode} mode.\$' | awk '{ print \$1 }' | uniq | wc -l | grep 2",
          }
        }
      }
    }
    'enforce':
    {
      exec { "set apparmor ${mode}":
        command => "aa-${mode} ${apparmor::params::apparmor_dir}/${profile}",
        require => Package['apparmor-utils'],
        onlyif  => "apparmor_status | grep -vE '0 profiles are loaded.\$' | grep -E ' profiles are loaded.\$| profiles are in ${mode} mode.\$' | awk '{ print \$1 }' | uniq | wc -l | grep 2",
      }
    }
    default: { fail('Unsupported')}
  }

}

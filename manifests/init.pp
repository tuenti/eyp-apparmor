# = Class: apparmor
#
# This is the main apparmor class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*mode*]
#  Sets the mode for a profile/s
#  Allowed values are [ 'complain', 'enforce', 'disable' ]
#
# [*profile*]
#  Can be a profile under the profiles folder or * for everything 

class apparmor(
                String $mode    = $apparmor::params::mode,
                String $profile = $apparmor::params::profile
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

          exec { "set apparmor enforce for ${profile}":
            command => "aa-enforce ${apparmor::params::apparmor_dir}/${profile}; exit 0",
            require => Package['apparmor-utils'],
            unless  => 'apparmor_status | grep -E \'0 profiles are loaded.\$\'',
          }

          exec { "set apparmor ${mode} for ${profile}":
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
          exec { "set apparmor from ${::eyp_apparmor_current_status} to enforce for ${profile}":
            command => "aa-enforce ${apparmor::params::apparmor_dir}/${profile}",
            require => Package['apparmor-utils'],
          }
          exec { "set apparmor from ${::eyp_apparmor_current_status} to ${mode} for ${profile}":
            command => "aa-${mode} ${apparmor::params::apparmor_dir}/${profile}",
            require => Exec[ "set apparmor ${mode} for ${profile}" ],
            # onlyif  => "apparmor_status | grep ${profile}",
            onlyif    => 'aa-status  --json | jq  -r  '.profiles  | with_entries(select(.key|match("${profile}";"i")))' | grep -q ${profile}',
          }
        }
        default:
        {
          exec { "set apparmor from ${::eyp_apparmor_current_status} to ${mode} for ${profile}":
            command => "aa-${mode} ${apparmor::params::apparmor_dir}/${profile}",
            require => Package['apparmor-utils'],
            # unless  => "apparmor_status | grep ${profile}",
            unless  => 'aa-status  --json | jq  -r  '.profiles  | with_entries(select(.key|match("${profile}";"i")))' | grep -q ${profile}',
          }
        }
      }
    }
    'enforce':
    {
      exec { "set apparmor ${mode} for ${profile}":
        command => "aa-${mode} ${apparmor::params::apparmor_dir}/${profile}",
        require => Package['apparmor-utils'],
        # onlyif  => "apparmor_status | grep -q ${profile}",
        onlyif    => 'aa-status  --json | jq  -r  '.profiles  | with_entries(select(.key|match("${profile}";"i")))' | grep -q ${profile}',
      }
    }
    default: { fail('Unsupported')}
  }
}

class apparmor ($mode='disable') inherits params {

  validate_re($mode, [ '^complain$', '^enforce$', '^disable$' ], "not a valid mode")

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  package { 'apparmor-utils':
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
          # no se pa pasa , pero faig el enforce primjer per poder fer el disable
          # root@prephp1:~# aa-disable /etc/apparmor.d/*
          # Profile for /etc/apparmor.d/abstractions not found, skipping
          # Profile for /etc/apparmor.d/cache not found, skipping
          # Profile for /etc/apparmor.d/disable not found, skipping
          # Profile for /etc/apparmor.d/force-complain not found, skipping
          # Profile for /etc/apparmor.d/local not found, skipping
          # Disabling /etc/apparmor.d/sbin.dhclient.
          # Traceback (most recent call last):
          #   File "/usr/sbin/aa-disable", line 30, in <module>
          #     tool.cmd_disable()
          #   File "/usr/lib/python3/dist-packages/apparmor/tools.py", line 136, in cmd_disable
          #     self.unload_profile(profile)
          #   File "/usr/lib/python3/dist-packages/apparmor/tools.py", line 251, in unload_profile
          #     raise apparmor.AppArmorException(cmd_info[1])
          # apparmor.common.AppArmorException: '/sbin/apparmor_parser: Unable to remove "/sbin/dhclient".  Profile doesn\'t exist\n'
          # root@prephp1:~# apparmor_status
          # apparmor module is loaded.
          # 1 profiles are loaded.
          # 1 profiles are in enforce mode.
          #    /usr/sbin/tcpdump
          # 0 profiles are in complain mode.
          # 0 processes have profiles defined.
          # 0 processes are in enforce mode.
          # 0 processes are in complain mode.
          # 0 processes are unconfined but have a profile defined.
          # root@prephp1:~# aa-enforce /etc/apparmor.d/*
          # Profile for /etc/apparmor.d/abstractions not found, skipping
          # Profile for /etc/apparmor.d/cache not found, skipping
          # Profile for /etc/apparmor.d/disable not found, skipping
          # Profile for /etc/apparmor.d/force-complain not found, skipping
          # Profile for /etc/apparmor.d/local not found, skipping
          # Setting /etc/apparmor.d/sbin.dhclient to enforce mode.
          # Profile for /etc/apparmor.d/tunables not found, skipping
          # Setting /etc/apparmor.d/usr.sbin.rsyslogd to enforce mode.
          # Setting /etc/apparmor.d/usr.sbin.tcpdump to enforce mode.
          # root@prephp1:~# aa-disable /etc/apparmor.d/*
          # Profile for /etc/apparmor.d/abstractions not found, skipping
          # Profile for /etc/apparmor.d/cache not found, skipping
          # Profile for /etc/apparmor.d/disable not found, skipping
          # Profile for /etc/apparmor.d/force-complain not found, skipping
          # Profile for /etc/apparmor.d/local not found, skipping
          # Disabling /etc/apparmor.d/sbin.dhclient.
          # Profile for /etc/apparmor.d/tunables not found, skipping
          # Disabling /etc/apparmor.d/usr.sbin.rsyslogd.
          # Disabling /etc/apparmor.d/usr.sbin.tcpdump.
          # root@prephp1:~# apparmor_status
          # apparmor module is loaded.
          # 0 profiles are loaded.
          # 0 profiles are in enforce mode.
          # 0 profiles are in complain mode.
          # 0 processes have profiles defined.
          # 0 processes are in enforce mode.
          # 0 processes are in complain mode.
          # 0 processes are unconfined but have a profile defined.
          # root@prephp1:~#

          exec { "set apparmor enforce":
            #command => "aa-enforce /etc/apparmor.d/*; exit 0",
            command => 'bash -c \'for i in $(find /etc/apparmor.d -maxdepth 1 -type f); do aa-enforce $i; done; exit 0\'',
            require => Package['apparmor-utils'],
            unless  => "apparmor_status | grep -E '0 profiles are loaded.\$'",
          }

          exec { "set apparmor $mode":
            #command => "aa-${mode} /etc/apparmor.d/*",
            command => "bash -c 'for i in $(find /etc/apparmor.d -maxdepth 1 -type f); do aa-${mode} \$i; done; exit 0'",
            require => Exec["set apparmor enforce"],
            unless  => "apparmor_status | grep -E '0 profiles are loaded.\$'",
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
          exec { "set apparmor enforce":
            command => "aa-enforce /etc/apparmor.d/*",
            require => Package['apparmor-utils'],
          }

          exec { "set apparmor $mode":
            command => "aa-${mode} /etc/apparmor.d/*",
            require => Exec["set apparmor enforce"],
            onlyif => "apparmor_status | grep -vE '0 profiles are loaded.\$' | grep -E ' profiles are loaded.\$| profiles are in ${mode} mode.\$' | awk '{ print \$1 }' | uniq | wc -l | grep 2",
          }
        }
        default:
        {
          exec { "set apparmor $mode":
            command => "aa-${mode} /etc/apparmor.d/*",
            require => Package['apparmor-utils'],
            onlyif => "apparmor_status | grep -vE '0 profiles are loaded.\$' | grep -E ' profiles are loaded.\$| profiles are in ${mode} mode.\$' | awk '{ print \$1 }' | uniq | wc -l | grep 2",
          }
        }
      }
    }
    'enforce':
    {
      exec { "set apparmor $mode":
        command => "aa-${mode} /etc/apparmor.d/*",
        require => Package['apparmor-utils'],
        onlyif => "apparmor_status | grep -vE '0 profiles are loaded.\$' | grep -E ' profiles are loaded.\$| profiles are in ${mode} mode.\$' | awk '{ print \$1 }' | uniq | wc -l | grep 2",
      }
    }
  }

}

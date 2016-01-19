class apparmor::params {

	case $::osfamily
	{
		'redhat':
    {
      fail("This is my sandbox, I'm not allowed to go in the deep end - Ralph Wiggum")
		}
		'Debian':
		{
			case $::operatingsystem
			{
				'Ubuntu':
				{
					case $::operatingsystemrelease
					{
						/^14.*/:
						{
						}
						default: { fail("Unsupported Ubuntu version! - $::operatingsystemrelease")  }
					}
				}
				'Debian': { fail("Unsupported")  }
				default: { fail("Unsupported Debian flavour!")  }
			}
		}
		default: { fail("Unsupported OS!")  }
	}
}

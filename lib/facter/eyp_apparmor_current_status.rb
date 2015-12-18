
Facter.add('eyp_apparmor_current_status') do
    setcode do
        Facter::Util::Resolution.exec('bash -c \'if [ ! -z "$(which apparmor_status 2>/dev/null)" ]; then export CURRENT=$(apparmor_status 2> /dev/null | grep \'"\'"\' profiles are\'"\'"\' | sort -n | tail -n2| head -n1 | awk \'"\'"\'$1 != 0 { print $5 }\'"\'"\'); if [ -z "$CURRENT" ]; then echo disabled; else echo $CURRENT; fi; fi;\'')
    end
end

require 'spec_helper'
describe 'apparmor', :type => 'class' do

  context 'Ubuntu 14' do
    let :facts do
    {
            :osfamily => 'Debian',
            :operatingsystem => 'Ubuntu',
            :operatingsystemrelease => '14.0',
    }
    end

    it { should contain_class('apparmor') }
  end

  context 'RH' do
    let :facts do
    {
            :osfamily => 'RedHat',
    }
    end

    it {
            expect { should raise_error(Puppet::Error) }
    }
  end

  context 'best OS ever' do
    let :facts do
    {
            :osfamily => 'SOFriki',
    }
    end

    it {
            expect { should raise_error(Puppet::Error) }
    }
  end

  context 'noOS defined' do
    it {
            expect { should raise_error(Puppet::Error) }
    }
  end


end

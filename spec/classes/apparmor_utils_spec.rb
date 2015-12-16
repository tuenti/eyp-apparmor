require 'spec_helper'
describe 'apparmor', :type => 'class' do

  context 'apparmor-utils are installed' do
    let :facts do
    {
            :osfamily => 'Debian',
            :operatingsystem => 'Ubuntu',
            :operatingsystemrelease => '14.0',
    }
    end

    it {
            should contain_package('apparmor-utils')
    }
  end
end

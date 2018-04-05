require 'spec_helper'

describe 'netdata' do
  on_os_under_test.each do |os, facts|

    context "on #{os}" do

     let(:facts) do
        facts
      end

      facts.merge!({ 
        :is_pe                  => false,
        :selinux                => false,
      })

      case facts[:operatingsystem]
	when 'Ubuntu'
          if facts[:operatingsystemmajrelease] <= '14.10'
	    supports_uninstall = false
          else
	    supports_uninstall = true
          end
      else
	  supports_uninstall = true
      end

      case facts[:operatingsystemmajrelease]
        when /^(14|6)/
          service_file = '/etc/init.d/netdata'
      else
          service_file = '/etc/systemd/system/netdata.service'
      end

      let(:params) do
        {
	  :ensure => 'absent',
        }.merge(overridden_params)
      end
      if supports_uninstall == true
        describe "uninstall netdata on #{os}" do
          let(:overridden_params) do {
          } end
  
          it { should compile.with_all_deps }
          it { is_expected.to contain_class('netdata::uninstall') }
  	  it { is_expected.to contain_file('/etc/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/opt/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/usr/sbin/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/usr/share/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/usr/libexec/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/var/lib/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/var/cache/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/var/log/netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_file("#{service_file}").with('ensure' => 'absent') }
  	  it { is_expected.to contain_file('/etc/cron.daily/netdata-updater.sh').with('ensure' => 'absent') }
  	  it { is_expected.to contain_user('netdata').with('ensure' => 'absent') }
  	  it { is_expected.to contain_group('netdata').with('ensure' => 'absent') }
        end
      end
    end
  end
end

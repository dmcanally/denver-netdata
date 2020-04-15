require 'spec_helper'

describe 'netdata' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:params) do
        {
          ensure: 'absent',
        }.merge(overridden_params)
      end

      facts[:is_pe] = false
      facts[:selinux] = false

      service_file = case facts[:operatingsystemmajrelease]
                     when %r{^(14|6)}
                       '/etc/init.d/netdata'
                     else
                       '/etc/systemd/system/netdata.service'
                     end

      describe "uninstall netdata on #{os}" do
        let(:overridden_params) do
          {}
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('netdata::uninstall') }
        it { is_expected.to contain_file('/etc/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file('/opt/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file('/usr/sbin/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file('/usr/share/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file('/usr/libexec/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file('/var/lib/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file('/var/cache/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file('/var/log/netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_file(service_file.to_s).with('ensure' => 'absent') }
        it { is_expected.to contain_file('/etc/cron.daily/netdata-updater.sh').with('ensure' => 'absent') }
        it { is_expected.to contain_user('netdata').with('ensure' => 'absent') }
        it { is_expected.to contain_group('netdata').with('ensure' => 'absent') }
      end
    end
  end
end

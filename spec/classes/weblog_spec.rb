require 'spec_helper'

describe 'netdata' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:node){ 'netdata.example.com' }

      let(:facts) do
        facts
      end

      facts.merge!({ 
        :is_pe    => false,
        :selinux  => false,
      })

      case facts[:operatingsystemrelease]
        when /^(14|6)/
          service_file = '/etc/init.d/netdata'
      else
          service_file = '/etc/systemd/system/netdata.service'
      end

      let(:params) do
        {
        }.merge(overridden_params)
      end

      let(:post_condition) { "netdata::plugin::web_log {'example.com': logfile => '/var/log/nginx/example.com.log' } "}

      describe "apply netdata with web_log plugin on #{os}" do
        let(:overridden_params) do {
        } end

        it { should compile.with_all_deps }
	it { is_expected.to contain_class('netdata::params') }
	it { is_expected.to contain_class('netdata::install') }
	it { is_expected.to contain_class('netdata::config') }
	it { is_expected.to contain_class('netdata::plugin') }
	it { is_expected.to contain_class('netdata::service') }
	it { is_expected.to contain_exec('install') }
	it { is_expected.to contain_service('netdata') }
        it { is_expected.to contain_file("#{service_file}").with('ensure' => 'present') }
        it { verify_concat_fragment_exact_contents(catalogue, 'stream.conf+01_includes', ['[stream]','  enabled = no',]) }
	it { should contain_concat('/opt/netdata/etc/netdata/python.d/web_log.conf') }
        it { verify_concat_fragment_contents(catalogue, 'web_log.conf+01', /THIS FILE IS MANAGED BY PUPPET/) }
	it { verify_concat_fragment_exact_contents(catalogue, 'web_log.conf+02_example.com', [
            'example.com:',
	    "  name: 'example.com'",
            "  path: '/var/log/nginx/example.com.log'",
        ]) }
	it { is_expected.to contain_file('/opt/netdata/etc/netdata/netdata.conf').with_content(/hostname = netdata.example.com/) }
	it { is_expected.to contain_concat('/opt/netdata/etc/netdata/stream.conf') }

      end
    end
  end
end

require 'spec_helper'

describe 'netdata' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:node){ 'netdata.example.com' }

      let(:facts) do
        facts
      end

      facts.merge!({ 
        :is_pe                  => false,
        :selinux                => false,
      })

      let(:params) do
        {
          :memory_mode          => 'none',
          :web_mode             => 'none',
          :remote_master        => 'netdata-master.example.com',
          :remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
          :remote_registry      => 'netdata-master.example.com',
          :registry_group       => 'office1',
        }.merge(overridden_params)
      end

      describe "netdata is slave on #{os}" do
        let(:overridden_params) do {
        } end

        it { should compile.with_all_deps }
	it { is_expected.to contain_class('netdata::install') }
	it { is_expected.to contain_class('netdata::config') }
	it { is_expected.to contain_class('netdata::service') }
	it { is_expected.to contain_exec('install') }
	it { is_expected.to contain_service('netdata') }
        it { verify_concat_fragment_exact_contents(catalogue, 'stream.conf+01_includes', [
             '[stream]',
             '  enabled = yes',
             '  api key = 9a83b18a-5cdb-4baf-8958-ad291ab781d3',
             '  destination = netdata-master.example.com:19999',
             ]) }
	it { is_expected.to contain_file('/opt/netdata/etc/netdata/netdata.conf').with_content(/memory mode = none/) }
	it { is_expected.to contain_file('/opt/netdata/etc/netdata/netdata.conf').with_content(/registry hostname = office1/) }
	it { is_expected.to contain_concat('/opt/netdata/etc/netdata/stream.conf') }

      end
    end
  end
end

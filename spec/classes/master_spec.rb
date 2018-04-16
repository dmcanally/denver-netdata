require 'spec_helper'

describe 'netdata' do
  on_os_under_test.each do |os, facts|

    let(:node){ 'netdata-master.example.com' }

    context "on #{os}" do
      let(:facts) do
        facts
      end

      facts.merge!({ 
        :is_pe                  => false,
        :selinux                => false,
      })

      let(:params) do
        {
          :master => true,
        }.merge(overridden_params)
      end

      let(:post_condition) { "netdata::stream {'9a83b18a-5cdb-4baf-8958-ad291ab781d3': } "}

      describe "netdata as master on #{os}" do
        let(:overridden_params) do {
        } end

        it { should compile.with_all_deps }
	it { is_expected.to contain_class('netdata::install') }
	it { is_expected.to contain_class('netdata::config') }
	it { is_expected.to contain_exec('install') }
	it { is_expected.to contain_service('netdata') }
        it { verify_concat_fragment_exact_contents(catalogue, 'stream.conf+01_includes', ['[stream]','  enabled = no',]) }
        it { verify_concat_fragment_exact_contents(catalogue, 'stream.conf+10_9a83b18a-5cdb-4baf-8958-ad291ab781d3', [
            '[9a83b18a-5cdb-4baf-8958-ad291ab781d3]',
            '  enabled = yes',
            '  default history = 3600',
            '  default memory mode = save',
            '  health enabled by default = auto',
            "  allow from = *",
	  ])}
	it { is_expected.to contain_file('/opt/netdata/etc/netdata/netdata.conf').with_content(/hostname = netdata-master.example.com/) }
	it { is_expected.to contain_concat('/opt/netdata/etc/netdata/stream.conf') }

      end
    end
  end
end

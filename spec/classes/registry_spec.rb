require 'spec_helper'

describe 'netdata' do
  on_os_under_test.each do |os, facts|

    let(:node){ 'netdata.example.com' }

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
          :registry => true,
        }.merge(overridden_params)
      end

      describe "netdata is registry on #{os}" do
        let(:overridden_params) do {
        } end

        it { should compile.with_all_deps }
	it { is_expected.to contain_class('netdata::install') }
	it { is_expected.to contain_class('netdata::config') }
	it { is_expected.to contain_exec('install') }
	it { is_expected.to contain_service('netdata') }
        it { verify_concat_fragment_exact_contents(catalogue, 'stream.conf+01_includes', ['[stream]','  enabled = no',]) }
	it { is_expected.to contain_file('/opt/netdata/etc/netdata/netdata.conf').with_content(/\[registry\]\n  enabled = yes/) }
	it { is_expected.to contain_concat('/opt/netdata/etc/netdata/stream.conf') }


      end
    end
  end
end

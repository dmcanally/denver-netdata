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

      let(:params) do
        {
        }.merge(overridden_params)
      end

      describe "apply netdata on #{os}" do
        let(:overridden_params) do {
        } end

        it { 
          should compile.with_all_deps
	  is_expected.to contain_class('netdata::install')
	  is_expected.to contain_class('netdata::config')
	  is_expected.to contain_class('netdata::service')
	  is_expected.to contain_exec('install')
	  is_expected.to contain_service('netdata')
          verify_concat_fragment_exact_contents(catalogue, 'stream.conf+01_includes', ['  enabled = no',])
	  is_expected.to contain_file('/opt/netdata/etc/netdata/netdata.conf').with_content(/hostname = netdata.example.com/)
	  is_expected.to contain_concat('/opt/netdata/etc/netdata/stream.conf')
        }


      end
    end
  end
end

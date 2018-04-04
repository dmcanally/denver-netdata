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

      let(:params) do
        {
	  :ensure => 'absent',
        }.merge(overridden_params)
      end

      describe "apply netdata on #{os}" do
        let(:overridden_params) do {
        } end

        it {
          should compile.with_all_deps
          is_expected.to contain_class('netdata::uninstall')
          is_expected.to contain_exec('uninstall')
	  is_expected.to contain_file('/opt/netdata').with('ensure' => 'absent')
        }

      end
    end
  end
end

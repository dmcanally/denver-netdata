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
          :remote_master        => 'netdata-master.example.com',
	  :remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
	  :remote_registry      => 'netdata-master.example.com',
        }.merge(overridden_params)
      end

      describe "netdata is slave on #{os}" do
        let(:overridden_params) do {
        } end

        it { should compile.with_all_deps }

      end
    end
  end
end

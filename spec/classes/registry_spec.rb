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
          :registry => true,
        }.merge(overridden_params)
      end

      describe "netdata is registry on #{os}" do
        let(:overridden_params) do {
        } end

        it { should compile.with_all_deps }

      end
    end
  end
end

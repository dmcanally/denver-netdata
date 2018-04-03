require 'spec_helper'

describe 'netdata::stream' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :title do '9a83b18a-5cdb-4baf-8958-ad291ab781d3' end

      describe 'minimal parameters' do
        let :params do {
          :history => 60,
	  :memory_mode => 'none',
	  :health_enable => 'no',
	  :allow_from => '10.*',
        } end

        let :facts do
          facts
        end

        facts.merge!({
          :is_pe                  => false,
          :selinux                => false,
        })


        let :pre_condition do
          "class { '::netdata': master => true}"
        end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'stream.conf+10_9a83b18a-5cdb-4baf-8958-ad291ab781d3', [
            '[9a83b18a-5cdb-4baf-8958-ad291ab781d3]',
            '    enabled = yes',
            '    default history = 60',
            '    default memory mode = none',
            '    health enabled by default = no',
            "    allow from = '10.*'",
          ])
        }
      end
    end
  end
end


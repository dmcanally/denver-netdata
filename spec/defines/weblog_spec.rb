require 'spec_helper'

describe 'netdata::plugin::web_log' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :title do 'example.com' end

      describe 'minimal parameters' do
        let :params do {
          :logfile => '/var/log/nginx/example.com',
        } end

        let :facts do
          facts
        end

        facts.merge!({
          :is_pe                  => false,
          :selinux                => false,
        })


        let :pre_condition do
          "class { '::netdata': }"
        end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'web_log.conf+02_example.com', [
            'example.com:',
	    "  name: 'example.com'",
            "  path: '/var/log/nginx/example.com'",
          ])
        }
      end
    end
  end
end


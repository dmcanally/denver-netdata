require 'spec_helper'

describe 'netdata::stream' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :title do
        '9a83b18a-5cdb-4baf-8958-ad291ab781d3'
      end

      describe 'minimal parameters' do
        let :params do
          {
          }
        end
        let :facts do
          facts
        end
        let :pre_condition do
          "class { '::netdata': master => true}"
        end

        facts[:is_pe] = false
        facts[:selinux] = false

        it {
          verify_concat_fragment_exact_contents(catalogue, 'stream.conf+10_9a83b18a-5cdb-4baf-8958-ad291ab781d3', [
                                                  '[9a83b18a-5cdb-4baf-8958-ad291ab781d3]',
                                                  '  enabled = yes',
                                                  '  default history = 3600',
                                                  '  default memory mode = save',
                                                  '  health enabled by default = auto',
                                                  '  allow from = *',
                                                ])
        }
      end
    end
  end
end

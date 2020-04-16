require 'spec_helper'

describe 'netdata' do
  on_supported_os.each do |os, facts|
    let(:node) { 'netdata.example.com' }

    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:params) do
        {
          registry: true,
        }.merge(overridden_params)
      end

      facts[:is_pe] = false
      facts[:selinux] = false

      describe "netdata is registry on #{os}" do
        let(:overridden_params) do
          {
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('netdata::install') }
        it { is_expected.to contain_class('netdata::config') }
        it { is_expected.to contain_exec('install') }
        it { is_expected.to contain_service('netdata') }
        it { contain_concat_fragment(catalogue, 'stream.conf+01_includes', ['[stream]', '  enabled = no']) }
        it { is_expected.to contain_file('/opt/netdata/etc/netdata/netdata.conf').with_content(%r{\[registry\]\n  enabled = yes}) }
        it { is_expected.to contain_concat('/opt/netdata/etc/netdata/stream.conf') }
      end
    end
  end
end

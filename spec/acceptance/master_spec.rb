require 'spec_helper_acceptance'

describe 'master installation' do

  hostname = fact('hostname')

  let(:pp) do
    <<-EOS

    class { '::netdata': 
      master => true,
    }

    netdata::stream {'9a83b18a-5cdb-4baf-8958-ad291ab781d3': }

    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service('netdata') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe file('/opt/netdata/etc/netdata/netdata.conf') do
    it { is_expected.to contain(/hostname = #{hostname}/)}
  end

  describe file('/opt/netdata/etc/netdata/stream.conf') do
    it { is_expected.to contain(/\[9a83b18a-5cdb-4baf-8958-ad291ab781d3\]/)}
  end

  describe port(19999) do
    it { is_expected.to be_listening.on('0.0.0.0').with('tcp') }
  end

end

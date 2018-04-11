require 'spec_helper_acceptance'

describe 'slave installation' do

  hostname = fact('hostname')

  let(:pp) do
    <<-EOS

    class { '::netdata': 
      remote_master        => 'netdata-master.example.com',
      remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
      remote_registry      => 'netdata-master.example.com',
      registry_group       => 'office1',
      web_mode             => 'none',
      memory_mode          => 'none',
    }

    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service('netdata') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(19999) do
    it { is_expected.to_not be_listening.on('0.0.0.0').with('tcp') }
  end

  describe file('/opt/netdata/etc/netdata/netdata.conf') do
    it { is_expected.to contain(/hostname = #{hostname}/)}
    it { is_expected.to contain(/registry to announce = http:\/\/netdata-master.example.com/)}
    it { is_expected.to contain(/registry hostname = office1: #{hostname}/)}
    it { is_expected.to contain(/memory mode = none/)}
    it { is_expected.to contain(/  mode = none/)}
    it { is_expected.to contain(/registry hostname = office1: #{hostname}/)}
  end

end

require 'spec_helper_acceptance'

describe 'bind_rndc plugin test' do

  hostname = fact('hostname')

  let(:pp) do
    <<-EOS

    class { '::netdata': }
    netdata::plugin::bind_rndc {'example.com': }

    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service('netdata') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(19999) do
    it { is_expected.to be_listening.on('0.0.0.0').with('tcp') }
  end

  describe file('/opt/netdata/etc/netdata/netdata.conf') do
    it { is_expected.to contain(/hostname = #{hostname}/)}
  end

  describe file('/opt/netdata/etc/netdata/python.d/bind_rndc.conf') do
    it { is_expected.to contain(/THIS FILE IS MANAGED BY PUPPET/)}
    it { is_expected.to contain(/example\.com/)}
  end


end

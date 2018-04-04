require 'spec_helper_acceptance'

describe 'slave installation' do

  let(:pp) do
    <<-EOS

    class { '::netdata': 
      remote_master   => 'netdata-master.example.com',
      remote_master_apikey => '9a83b18a-5cdb-4baf-8958-ad291ab781d3',
      remote_registry => 'netdata-master.example.com',
    }

    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service('netdata') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

end

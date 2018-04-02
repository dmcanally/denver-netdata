require 'spec_helper_acceptance'

describe 'Simple installation' do

  let(:pp) do
    <<-EOS

    class { '::netdata': }

    EOS
  end

  it_behaves_like 'a idempotent resource'

  #describe service('netdata') do
  #  it { is_expected.to be_enabled }
  #  it { is_expected.to be_running }
  #end

end

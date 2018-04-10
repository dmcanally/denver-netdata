require 'spec_helper_acceptance'

describe 'uninstall' do

  let :pre_condition do
    "class { '::netdata': }"
  end

  let(:pp) do
    <<-EOS

    class { '::netdata':
      ensure => 'absent',
    }

    EOS
  end

  it_behaves_like 'a idempotent resource'

end

require 'serverspec'

set :backend, :exec

context 'config file' do
  describe file('/etc/named.conf') do
    it { is_expected.to contain('10.0.0.12').from(/listen-on/).to(/allow-recursion/) }
  end
end

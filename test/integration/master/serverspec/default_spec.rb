require 'serverspec'

set :backend, :exec

context 'install' do
  ['bind', 'bind-utils'].each do |pkg|
    describe package(pkg) do
      it { is_expected.to be_installed }
    end
  end

  describe group('named') do
    it { is_expected.to exist }
  end

  describe user('named') do
    it { is_expected.to exist }
    it { is_expected.to belong_to_group 'named' }
    it { is_expected.to have_login_shell '/sbin/nologin' }
  end
end

context 'directories' do
  [
    '/var/named/',
    '/var/named/data',
    '/var/named/dynamic',
    '/var/named/slaves',
    '/var/named/masters',
  ]
  .each do |dir|
    describe file(dir) do
      it { is_expected.to be_directory }
      it { is_expected.to be_grouped_into 'named' }
    end
  end
end

context 'data files' do
  [
    '/var/named/data/named.run',
    '/var/named/named.ca',
    '/var/named/named.empty',
    '/var/named/named.localhost',
    '/var/named/named.loopback',
    '/var/named/named.root',
    '/var/named/masters/0.0.10.in-addr.arpa.db',
    '/var/named/masters/example.com.db',
  ]
  .each do |file|
    describe file(file) do
      it { is_expected.to be_file }
      it { is_expected.to be_grouped_into 'named' }
    end
  end
end

context 'config file' do
  describe file('/etc/named.conf') do
    its(:content) { is_expected.to match /zone.*0.0.10.in-addr.arpa/ }
    its(:content) { is_expected.to match /zone.*example.com/ }
  end
end

context 'log files' do
  describe file('/var/log/messages') do
    its(:content) { is_expected.to match /starting BIND/ }
    its(:content) { is_expected.to match /loaded serial 2016010100/ }
    its(:content) { is_expected.to match /all zones loaded/ }
    its(:content) { is_expected.to match /sending notifies/ }
  end
end

context 'service' do
  describe service('named') do
    it { is_expected.to be_running }
  end

  [53, 953].each do |port|
    describe port(port) do
      it { is_expected.to be_listening.with('tcp') }
    end
  end
end

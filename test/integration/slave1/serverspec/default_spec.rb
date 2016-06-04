require 'serverspec'

set :backend, :exec

context 'directories' do
  [
    '/var/named/',
    '/var/named/data',
    '/var/named/dynamic',
    '/var/named/slaves',
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
    its(:content) { is_expected.to contain('type slave;').
      from(/^zone "0.0.10.in-addr.arpa"/).to(/^zone "example.com"/) }
    its(:content) { is_expected.to contain('file "slaves/0.0.10.in-addr.arpa.db";').
      from(/^zone "0.0.10.in-addr.arpa"/).to(/^zone "example.com"/) }
    its(:content) { is_expected.to contain('masters {').
      from(/^zone "0.0.10.in-addr.arpa"/).to(/^zone "example.com"/) }
    its(:content) { is_expected.to contain('10.0.0.10;').
      from(/^zone "0.0.10.in-addr.arpa"/).to(/^zone "example.com"/) }
  end
end

context 'log files' do
  describe file('/var/log/messages') do
    its(:content) { is_expected.to match /transfer of '0.0.10.in-addr.arpa\/IN' from 10.0.0.10#53: Transfer completed:/ }
    its(:content) { is_expected.to match /transfer of 'example.com\/IN' from 10.0.0.10#53: Transfer completed:/ }
  end
end

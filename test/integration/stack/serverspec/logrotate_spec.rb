require 'serverspec'
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe 'magento-ng::logrotate' do
  describe file('/etc/logrotate.d/magento-site1') do
    it { should be_file }
    its(:content) { should match %r{^"/var/www/app/shared/public/var/log/\*\.log" \{$} }
    its(:content) { should match(/^\s*weekly$/) }
    its(:content) { should match(/^\s*rotate 4$/) }
  end
end

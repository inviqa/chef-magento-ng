require 'serverspec'
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe 'AOE Cron' do
  describe file('/etc/cron.d/magento-site1') do
    it { should be_file }
    its(:content) { should match %r{.*\* \* \* \* \* apache sh /docroot/scheduler_cron.sh --mode always.*} }
    its(:content) { should match %r{.*\* \* \* \* \* apache sh /docroot/scheduler_cron.sh --mode default.*} }
    its(:content) { should match %r{.*\*\/10 \* \* \* \* apache cd /docroot/shell && /usr/bin/php scheduler.php --action watchdog.*} }
    its(:content) { should match %r{.*\* \* \* \* \* apache sh /docroot/scheduler_cron.sh --mode default --excludeGroups excludegroup.*} }
    its(:content) { should match %r{.*\* \* \* \* \* apache sh /docroot/scheduler_cron.sh --mode default --includeJobs includejob.*} }
  end
end

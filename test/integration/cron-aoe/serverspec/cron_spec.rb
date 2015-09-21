require 'serverspec'
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe "AOE Cron" do
  describe file("/etc/cron.d/magento-site1-aoe-always") do
    it { should be_file }
    its(:content) { should match /.*\* \* \* \* \* apache sh \/docroot\/scheduler_cron.sh --mode always.*/ }
  end
  describe file("/etc/cron.d/magento-site1-aoe-default") do
    it { should be_file }
    its(:content) { should match /.*\* \* \* \* \* apache sh \/docroot\/scheduler_cron.sh --mode default.*/ }
  end
  describe file("/etc/cron.d/magento-site1-aoe-watchdog") do
    it { should be_file }
    its(:content) { should match /.*\*\/10 \* \* \* \* apache cd \/docroot\/shell && \/usr\/bin\/php scheduler.php --action watchdog.*/ }
  end
end
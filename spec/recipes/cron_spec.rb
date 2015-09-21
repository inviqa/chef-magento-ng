describe 'magento-ng::cron' do
  context 'with default attributes and no magento sites' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project1']['type'] = 'non-magento-site'
        node.set['apache']['sites']['project2']['type'] = 'non-magento-site'
      end.converge(described_recipe)
    end

    it "does not create cron.d file" do
      expect(chef_run).not_to create_cron_d('magento-project1')
      expect(chef_run).not_to create_cron_d('magento-project2')
    end

  end

  context 'with default attributes and one apache project site' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites'] = {}
        node.set['apache']['sites']['project']['type'] = 'magento'
        node.set['apache']['sites']['project']['docroot'] = '/var/www/project/current/public'
      end.converge(described_recipe)
    end

    it "creates project cron.d file" do
      expect(chef_run).to create_cron_d('magento-project').with(
        command: 'sh /var/www/project/current/public/cron.sh',
        user: 'www-data'
      )
    end
  end

   context 'with aow schedule and watchdog' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites'] = {}
        node.set['apache']['sites']['project']['type'] = 'magento'
        node.set['apache']['sites']['project']['docroot'] = '/var/www/project/current/public'
        node.set['apache']['sites']['project']['aoe_scheduler'] = true
        node.set['apache']['sites']['project']['watchdog'] = true
      end.converge(described_recipe)
    end

   it "creates project cron.d file using aoe schdule and watchdog" do
      expect(chef_run).to create_cron_d('magento-project').with(
        command: 'sh /var/www/project/current/public/schedule_cron.sh --mode always',
        command: 'sh /var/www/project/current/public/schedule_cron.sh --mode default',
        command: 'cd /var/www/project/current/public/shell && /usr/bin/php scheduler.php --action watchdog',
        user: 'www-data'
      )
    end
  end

   context 'with aoe schedule but no watchdog ' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites'] = {}
        node.set['apache']['sites']['project']['type'] = 'magento'
        node.set['apache']['sites']['project']['docroot'] = '/var/www/project/current/public'
        node.set['apache']['sites']['project']['aoe_scheduler'] = true
        node.set['apache']['sites']['project']['watchdog'] = false
      end.converge(described_recipe)
    end

   it "creates project cron.d file using aoe schduler and no watchdog" do
      expect(chef_run).to create_cron_d('magento-project').with(
        command: 'sh /var/www/project/current/public/schedule_cron.sh --mode always',
        command: 'sh /var/www/project/current/public/schedule_cron.sh --mode default',
        user: 'www-data'
      )
    end
  end

  context 'with default attributes and one nginx project site' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['apache']['sites'] = {}
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['docroot'] = '/var/www/project/current/public'
      end.converge(described_recipe)
    end

    it "creates project cron.d file" do
      expect(chef_run).to create_cron_d('magento-project').with(
        command: 'sh /var/www/project/current/public/cron.sh',
        user: 'www-data'
      )
    end
  end
end

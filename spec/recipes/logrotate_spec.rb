describe 'magento-ng::logrotate' do
  context 'with default attributes and no magento sites' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project1']['type'] = 'non-magento-site'
        node.set['apache']['sites']['project2']['type'] = 'non-magento-site'
      end.converge(described_recipe)
    end

    it 'does not create logrotate configuration' do
      expect(chef_run).not_to enable_logrotate_app('magento-project1')
      expect(chef_run).not_to enable_logrotate_app('magento-project2')
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

    it 'creates project logrotate configuration' do
      expect(chef_run).to enable_logrotate_app('magento-project')
        .with(path: '/var/www/project/current/public/var/log/*.log', missingok: nil, frequency: 'weekly', rotate: 4)
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

    it 'creates project logrotate configuration' do
      expect(chef_run).to enable_logrotate_app('magento-project')
        .with(path: '/var/www/project/current/public/var/log/*.log', missingok: nil, frequency: 'weekly', rotate: 4)
    end
  end

  context 'with capistrano' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['docroot'] = '/var/www/project/current/public'
        node.set['nginx']['sites']['project']['capistrano']['deploy_to'] = '/var/www/project'
      end.converge(described_recipe)
    end

    it 'creates project logrotate configuration' do
      expect(chef_run).to enable_logrotate_app('magento-project')
        .with(path: '/var/www/project/shared/public/var/log/*.log', missingok: nil, frequency: 'weekly', rotate: 4)
    end
  end

  context 'with extra logrotate params' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['docroot'] = '/var/www/project/current/public'
        node.set['nginx']['sites']['project']['capistrano']['deploy_to'] = '/var/www/project'
        node.set['nginx']['sites']['project']['logrotate']['delaycompress'] = true
      end.converge(described_recipe)
    end

    it 'creates project logrotate configuration' do
      expect(chef_run).to enable_logrotate_app('magento-project')
        .with(path: '/var/www/project/shared/public/var/log/*.log', delaycompress: nil, frequency: 'weekly', rotate: 4)
    end
  end
end

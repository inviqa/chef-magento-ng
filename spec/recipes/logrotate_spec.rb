describe 'magento-ng::logrotate' do
  context 'with default attributes and no magento sites' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project1']['type'] = 'non-magento-site'
        node.set['apache']['sites']['project2']['type'] = 'non-magento-site'
      end.converge(described_recipe)
    end

    it 'does not create logrotate configuration' do
      expect(chef_run).not_to create_template('/etc/logrotate.d/magento-project1')
      expect(chef_run).not_to create_template('/etc/logrotate.d/magento-project2')
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
      expect(chef_run).to create_template('/etc/logrotate.d/magento-project')
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
      expect(chef_run).to create_template('/etc/logrotate.d/magento-project')
    end
  end
end

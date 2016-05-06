describe 'magento-ng::stack' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'should include the cron recipe' do
    expect(chef_run).to include_recipe('magento-ng::cron')
  end

  it 'should include the etc-local recipe' do
    expect(chef_run).to include_recipe('magento-ng::etc-local')
  end
end

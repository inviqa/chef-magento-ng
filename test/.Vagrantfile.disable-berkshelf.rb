Vagrant.configure('2') do |config|
  config.berkshelf.enabled = false if Vagrant.has_plugin?('vagrant-berkshelf')
end

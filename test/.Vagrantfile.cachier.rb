Vagrant.configure('2') do |config|
  # The following configuration supports shared folders with host
  # aware configuration of NFS for performance benefits on unix based hosts
  require 'ffi'
  use_nfs = !FFI::Platform::IS_WINDOWS && ::File.exist?('/etc/sudoers.d/vagrant_nfs')
  has_cachier = Vagrant.has_plugin?('vagrant-cachier')

  config.vm.network 'private_network', type: 'dhcp'

  # Enable Vagrant Cachier, for speedy destroy/creates
  if has_cachier
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    if use_nfs
      # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
      # NFS for shared folders. This is also very useful for vagrant-libvirt if you
      # want bi-directional sync
      config.cache.synced_folder_opts = {
        type: :nfs,
        # The nolock option can be useful for an NFSv3 client that wants to avoid the
        # NLM sideband protocol. Without this option, apt-get might hang if it tries
        # to lock files needed for /var/cache/* operations. All of this can be avoided
        # by using NFSv4 everywhere. Please note that the tcp option is not the default.
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }
    end

    config.cache.enable :chef
    config.cache.enable :yum
    config.cache.enable :gem
  end

  config.vm.provision :chef_solo do |chef|
    chef.file_cache_path = chef.provisioning_path unless has_cachier

    # Mount chef folders via NFS for speed
    chef.synced_folder_type = 'nfs' if use_nfs
  end
end

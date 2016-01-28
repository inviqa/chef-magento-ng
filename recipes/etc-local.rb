%w( apache nginx ).each do |type|
  node[type]['sites'].each_pair do |name, site|
    next unless site['type'] == 'magento'

    magento = ConfigDrivenHelper::Util.immutablemash_to_hash(node['magento'])

    if site['magento']
      magento = ::Chef::Mixin::DeepMerge.hash_only_merge(
        magento,
        ConfigDrivenHelper::Util.immutablemash_to_hash(site['magento']))
    end

    if Chef::Config[:solo]
      missing_attrs = %w(
        crypt_key
      ).select { |attr| magento['app'][attr].nil? }.map { |attr| "node['#{type}']['sites']['#{name}']['magento']['app']['#{attr}']" }

      unless missing_attrs.empty?
        fail "You must set #{missing_attrs.join(', ')} in chef-solo mode."
      end
    else
      # generate all passwords
      ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
      node.set_unless[type]['sites'][name]['magento']['app']['crypt_key'] = secure_password
      magento['app']['crypt_key'] = node[type]['sites'][name]['magento']['app']['crypt_key']
      node.save
    end

    if site['capistrano']
      config_path = "#{site['capistrano']['deploy_to']}/shared/#{magento['app']['base_path']}"
    else
      config_path = site['docroot']
    end

    directory "#{config_path}/app/etc" do
      recursive true
      action :create
      not_if do
        ::File.exist?("#{config_path}/app/etc")
      end
    end

    template "#{config_path}/app/etc/local.xml" do
      source 'magento-local.xml.erb'
      mode 0644
      variables(
        :magento => magento
      )
    end
  end
end

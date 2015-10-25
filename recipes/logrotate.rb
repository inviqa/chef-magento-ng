%w( apache nginx ).each do |type|
  node[type]['sites'].each_pair do |name, site|
    next unless site['type'] == 'magento'

    magento = ConfigDrivenHelper::Util.immutablemash_to_hash(node['magento'])

    if site['magento']
      magento = ::Chef::Mixin::DeepMerge.hash_only_merge(
        magento,
        ConfigDrivenHelper::Util.immutablemash_to_hash(site['magento']))
    end

    if site['capistrano']
      config_path = "#{site['capistrano']['deploy_to']}/shared/#{magento['app']['base_path']}"
    else
      config_path = site['docroot']
    end

    logrotate_app "magento-#{name}" do
      path "#{config_path}/var/log/*.log"
      magento['logrotate'].each do |key, value|
        send key, value
      end unless magento['logrotate'].nil?
    end
  end
end

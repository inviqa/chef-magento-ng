#
# Cookbook Name:: magento-ng
# Recipe:: etc-local
#
# Copyright (C) 2015 Inviqa UK LTD
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

%w[apache nginx].each do |type|
  node[type]['sites'].each_pair do |name, site|
    next unless site['type'] == 'magento'

    magento = ConfigDrivenHelper::Util.immutablemash_to_hash(node['magento'])

    if site['magento']
      magento = ::Chef::Mixin::DeepMerge.hash_only_merge(
        magento,
        ConfigDrivenHelper::Util.immutablemash_to_hash(site['magento'])
      )
    end

    if Chef::Config[:solo]
      missing_attrs = %w[
        crypt_key
      ].select { |attribute| magento['app'][attribute].nil? }.map do |attribute|
        "node['#{type}']['sites']['#{name}']['magento']['app']['#{attribute}']"
      end

      raise "You must set #{missing_attrs.join(', ')} in chef-solo mode." unless missing_attrs.empty?
    else
      # generate all passwords
      %w[
        crypt_key
      ].select { |attribute| magento['app'][attribute].nil? }.map do |attribute|
        node.set_unless[type]['sites'][name]['magento']['app'][attribute] = secure_password
        node.save
      end
    end

    config_path = if site['capistrano']
                    "#{site['capistrano']['deploy_to']}/shared/#{magento['app']['base_path']}"
                  else
                    site['docroot']
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
      mode 0o0644
      variables(
        :magento => magento
      )
    end
  end
end

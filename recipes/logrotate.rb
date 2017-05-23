#
# Cookbook Name:: magento-ng
# Recipe:: logrotate
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

    config_path = if site['capistrano']
                    "#{site['capistrano']['deploy_to']}/shared/#{magento['app']['base_path']}"
                  else
                    site['docroot']
                  end

    logrotate_app "magento-#{name}" do
      path "#{config_path}/var/log/*.log"
      unless magento['logrotate'].nil?
        magento['logrotate'].each do |key, value|
          send key, value
        end
      end
    end
  end
end

#
# Cookbook Name:: magento-ng
# Recipe:: cron
#
# Copyright (C) 2015 Inviqa UK Limited
#
# All rights reserved - Do Not Redistribute
#

%w( apache nginx ).each do |type|
  node[type]['sites'].each do |name, site|
    next unless site['type'] == 'magento'

    if site['type'] == 'magento'
      include_recipe 'cron::default'

      primary_indicator_check = ''
      if site['clustered']
        primary_indicator_check = "bash -c '[ -f #{site['clustered']['primary_indicator']} ] && "
      end

      cron_d "magento-#{name}" do

        if site['aoe_scheduler']
          command "#{primary_indicator_check}sh #{site['docroot']}/schedule_cron.sh --mode always"
          command "#{primary_indicator_check}sh #{site['docroot']}/schedule_cron.sh --mode default"

          if site['watchdog']
            command "#{primary_indicator_check}cd #{site['docroot']}/shell && /usr/bin/php scheduler.php --action watchdog"
          end
        else
          command "#{primary_indicator_check}sh #{site['docroot']}/cron.sh"
        end

        if (!site['cron'].nil?) && site['cron']['user']
          user site['cron']['user']
        else
          case type
          when 'apache'
            user node['apache']['user']
          when 'nginx'
            user node['php-fpm']['pools']['www']['user'].nil? ? node['php-fpm']['user'] : node['php-fpm']['pools']['www']['user']
          end
        end
      end
    end
  end
end

name             'magento-ng'
maintainer       'Andy Thompson'
maintainer_email 'athompson@inviqa.com'
license          'All rights reserved'
description      'Installs/Configures magento-ng'
long_description 'Installs/Configures magento-ng'
version          '0.5.0'
source_url       'https://github.com/inviqa/chef-magento-ng'
issues_url       'https://github.com/inviqa/chef-magento-ng/issues'

depends 'config-driven-helper', '< 3.0'
depends 'cron', '>= 1.4'
depends 'logrotate', '>= 1.9'
depends 'php-fpm'

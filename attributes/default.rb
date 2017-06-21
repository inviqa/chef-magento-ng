default['magento']['db']['host'] = 'localhost'
default['magento']['db']['database'] = 'magentodb'
default['magento']['db']['username'] = 'magentouser'
default['magento']['db']['persistent'] = '0'
default['magento']['db']['active'] = '1'
default['magento']['db']['model'] = 'mysql4'
default['magento']['db']['initStatements'] = 'SET NAMES utf8'
default['magento']['db']['type'] = 'pdo_mysql'

default['magento']['db_connections']['default_setup'] = {}

default['magento']['app']['base_path'] = 'public'
default['magento']['app']['locale'] = 'en_GB'
default['magento']['app']['timezone'] = 'Europe/London'
default['magento']['app']['currency'] = 'GBP'
default['magento']['app']['session_save'] = 'db' # files|db|memcache
default['magento']['app']['admin_frontname'] = 'admin'
default['magento']['app']['use_rewrites'] = 'yes'
default['magento']['app']['use_secure'] = 'yes'
default['magento']['app']['use_secure_admin'] = 'yes'
default['magento']['app']['multi_session_save'] = 'db' # files|db|memcache|redis
default['magento']['app']['session_memcache_ip'] = '127.0.0.1'
default['magento']['app']['session_memcache_port'] = '11211'
default['magento']['app']['backend_cache'] = 'file' # apc|memcached|xcache|file|Cm_Cache_Backend_Redis
default['magento']['app']['slow_backend'] = 'database' # database|file
default['magento']['app']['backend_servers'] = []

default['magento']['redis']['host'] = '127.0.0.1'
default['magento']['redis']['port'] = '6379'
default['magento']['redis']['password'] = ''
default['magento']['redis']['timeout'] = '2.5'
default['magento']['redis']['database'] = '0'
default['magento']['redis']['full_page_cache_database'] = '1'
default['magento']['redis']['session_database'] = '2'
default['magento']['redis']['persistent'] = 'c'
default['magento']['redis']['full_page_cache_persistent'] = 'fpc'
default['magento']['redis']['session_persistent'] = 's'
default['magento']['redis']['force_standalone'] = '0'
default['magento']['redis']['connect_retries'] = '1'
default['magento']['redis']['automatic_cleaning_factor'] = '0'
default['magento']['redis']['compress_data'] = '1'
default['magento']['redis']['compress_tags'] = '1'
default['magento']['redis']['compress_threshold'] = '2048'
default['magento']['redis']['compression_lib'] = 'gzip'
default['magento']['redis']['lifetime_limit'] = '57600'
default['magento']['redis']['log_level'] = '4'
default['magento']['redis']['max_concurrency'] = '6'
default['magento']['redis']['break_after_frontend'] = '5'
default['magento']['redis']['fail_after'] = '10'
default['magento']['redis']['break_after_adminhtml'] = '30'
default['magento']['redis']['first_lifetime'] = '600'
default['magento']['redis']['bot_first_lifetime'] = '60'
default['magento']['redis']['bot_lifetime'] = '7200'
default['magento']['redis']['disable_locking'] = '0'
default['magento']['redis']['min_lifetime'] = '60'
default['magento']['redis']['max_lifetime'] = '2592000'
default['magento']['redis']['use_lua'] = '0'

default['magento']['global']['custom'] = ''
default['magento']['global']['extra_params'] = {
  'skip_process_modules_updates' => 1,
  'skip_process_modules_updates_dev_mode' => 1
}

default['magento']['cron_type'] = 'standard'
default['magento']['cron']['minute'] = '*'
default['magento']['aoe_scheduler']['always']['mode'] = 'always'
default['magento']['aoe_scheduler']['always']['minute'] = '*'
default['magento']['aoe_scheduler']['default']['mode'] = 'default'
default['magento']['aoe_scheduler']['default']['minute'] = '*'
default['magento']['aoe_scheduler']['watchdog']['mode'] = 'watchdog'
default['magento']['aoe_scheduler']['watchdog']['minute'] = '*/10'

default['magento']['logrotate']['frequency'] = 'weekly'
default['magento']['logrotate']['rotate'] = 4

%w[apache nginx].each do |type|
  default[type]['shared_config']['magento'] = {
    'clustered' => false,
    'type' => 'magento',
    'protocols' => %w[http https],
    'locations' => {
      '/app' => 'restricted',
      '/dev' => 'restricted',
      '/downloader' => 'restricted',
      '^/errors/.*\\.(xml|phtml)$' => {
        'type' => 'regex',
        'mode' => 'restricted'
      },
      '/includes' => 'restricted',
      '/lib' => 'restricted',
      '/media' => 'static',
      '/media/custom_options' => 'restricted',
      '/media/customer' => 'restricted',
      '/media/downloadable' => 'restricted',
      '/pkginfo' => 'restricted',
      '/report/config.xml' => 'restricted',
      '^(/index\.php)?/?(.+/)?rss/(catalog/(notifystock|review)|order/new)(/|$)' => 'restricted',
      '/shell' => 'restricted',
      '/skin' => 'static',
      '/var' => 'restricted',
      '/.gitignore' => 'restricted',
      '/composer.json' => 'restricted',
      '/cron.php' => 'restricted',
      '/cron.sh' => 'restricted',
      '/index.php.sample' => 'restricted',
      '/install.php' => 'restricted',
      '/mage' => 'restricted',
      '/php.ini.sample' => 'restricted',
      '/RELEASE_NOTES.txt' => 'restricted',

      '/\\.ht[^/]*$' => {
        'type' => 'regex',
        'mode' => 'restricted'
      }
    },
    'capistrano' => {
      'owner' => 'deploy',
      'group' => 'deploy',
      'shared_folders' => {
        'standard' => {
          'folders' => [
            'public/app/etc/'
          ]
        },
        'writeable' => {
          'owner' => 'apache',
          'group' => 'apache',
          'folders' => [
            'public/./media',
            'public/./sitemaps',
            'public/./staging',
            'public/./var'
          ]
        }
      }
    }
  }
end

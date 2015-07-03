default['magento']['db']['host'] = "localhost"
default['magento']['db']['database'] = "magentodb"
default['magento']['db']['username'] = "magentouser"
default['magento']['db']['persistent'] = '0'
default['magento']['db']['active'] = '1'
default['magento']['db']['model'] = "mysql4"
default['magento']['db']['initStatements'] = 'SET NAMES utf8'
default['magento']['db']['type'] = 'pdo_mysql'

default['magento']['db_connections']['default_setup'] = {}

default['magento']['app']['base_path'] = "public"
default['magento']['app']['locale'] = "en_GB"
default['magento']['app']['timezone'] = "Europe/London"
default['magento']['app']['currency'] = "GBP"
default['magento']['app']['session_save'] = "db" # files|db|memcache
default['magento']['app']['admin_frontname'] = "admin"
default['magento']['app']['use_rewrites'] = "yes"
default['magento']['app']['use_secure'] = "yes"
default['magento']['app']['use_secure_admin'] = "yes"
default['magento']['app']['multi_session_save'] = "db" # files|db|memcache|redis
default['magento']['app']['session_memcache_ip'] = "127.0.0.1"
default['magento']['app']['session_memcache_port'] = "11211"
default['magento']['app']['backend_cache'] = "file" # apc|memcached|xcache|file|Cm_Cache_Backend_Redis
default['magento']['app']['slow_backend'] = "database" # database|file
default['magento']['app']['backend_servers'] = Array.new

default['magento']['redis']['host'] = '127.0.0.1'
default['magento']['redis']['port'] = '6379'
default['magento']['redis']['timeout'] = '2.5'
default['magento']['redis']['database'] = '0'
default['magento']['redis']['full_page_cache_database'] = '1'
default['magento']['redis']['session_database'] = '2'
default['magento']['redis']['force_standalone'] = '0'
default['magento']['redis']['automatic_cleaning_factor'] = '0'
default['magento']['redis']['compress_data'] = '1'
default['magento']['redis']['compress_tags'] = '1'
default['magento']['redis']['compress_threshold'] = '2048'
default['magento']['redis']['compression_lib'] = 'gzip'

default['magento']['global']['custom'] = ''
default['magento']['global']['extra_params'] = {
  'skip_process_modules_updates' => 1,
  'skip_process_modules_updates_dev_mode' => 1,
}

%w( apache nginx ).each do |type|
  default[type]['shared_config']['magento'] = {
    'clustered' => false,
    'type' => 'magento',
    'protocols' => ['http', 'https'],
    'restricted_dirs' => [
      '/app/',
      '/downloader/',
      '/includes/',
      '/lib/',
      '/media/downloadable/',
      '/pkginfo/',
      '/report/config.xml',
      '/var/'
    ],
    'static_dirs' => [
      '/media/',
      '/skin/'
    ],
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

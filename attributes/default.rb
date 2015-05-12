%w( apache nginx ).each do |type|
  default[type]['shared_config']['magento'] = {
    'clustered' => false,
    'type' => 'magento',
    'protocols' => ['http', 'https'],
    'restricted_dirs' => [
      '/app/',
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

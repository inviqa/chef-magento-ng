describe 'magento-ng::etc-local' do
  let(:cdata_open) { Regexp.escape('<![CDATA[') }
  let(:cdata_close) { Regexp.escape(']]>') }

  shared_examples 'default local.xml' do
    it 'should write out the configuration with the environment' do
      expect(chef_run).to render_file(configuration_file)
        .with_content('<environment><![CDATA[]]></environment>')
    end

    it 'should write out the configuration with the crypt key' do
      expect(chef_run).to render_file(configuration_file)
        .with_content('<key><![CDATA[I am a random string!]]></key>')
    end

    it 'should write out the configuration with the extra parameters' do
      expect(chef_run).to render_file(configuration_file)
        .with_content('<skip_process_modules_updates><![CDATA[1]]></skip_process_modules_updates>')
      expect(chef_run).to render_file(configuration_file)
        .with_content('<skip_process_modules_updates_dev_mode><![CDATA[1]]></skip_process_modules_updates_dev_mode>')
    end

    it 'should write out the configuration with an empty database table prefix' do
      expect(chef_run).to render_file(configuration_file)
        .with_content('<table_prefix><![CDATA[]]></table_prefix>')
    end

    it 'should write out the configuration with the default database setup' do
      expected = %r{
        <default_setup>.*
          <host>#{cdata_open}localhost#{cdata_close}</host>.*
          <dbname>#{cdata_open}magentodb#{cdata_close}</dbname>.*
          <username>#{cdata_open}magentouser#{cdata_close}</username>.*
          <persistent>#{cdata_open}0#{cdata_close}</persistent>.*
          <active>#{cdata_open}1#{cdata_close}</active>.*
          <model>#{cdata_open}mysql4#{cdata_close}</model>.*
          <initStatements>#{cdata_open}SET\sNAMES\sutf8#{cdata_close}</initStatements>.*
          <type>#{cdata_open}pdo_mysql#{cdata_close}</type>.*
        </default_setup>
      }mx
      expect(chef_run).to render_file(configuration_file).with_content(match(expected))
    end

    it 'should write out the configuration with session save being database' do
      expect(chef_run).to render_file(configuration_file)
        .with_content('<session_save><![CDATA[db]]></session_save>')
    end

    it 'should write out the configuration with session save being database' do
      expect(chef_run).to render_file(configuration_file)
        .with_content('<session_save><![CDATA[db]]></session_save>')
    end

    it 'should write out the configuration without redis session settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content('<redis_session>')
    end

    it 'should write out the configuration without memcached session settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content('<session_save_path><![CDATA[tcp://')
    end

    it 'should write out the configuration with the cache backend being file' do
      expect(chef_run).to render_file(configuration_file)
        .with_content(match(%r{<cache>.*<backend><!\[CDATA\[file\]\]></backend>.*</cache>}m))
    end

    it 'should write out the configuration without redis cache settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content(match(%r{<cache>.*<backend_options>.*</cache>}m))
    end

    it 'should write out the configuration with the slow cache backend being database' do
      expect(chef_run).to render_file(configuration_file)
        .with_content(match(%r{<cache>.*<slow_backend><!\[CDATA\[database\]\]></slow_backend>.*</cache>}m))
    end

    it 'should write out the configuration without memcached cache settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content(match(%r{<cache>.*<memcached>.*</cache>}m))
    end

    it 'should write out the configuration without cache prefix settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content(match(%r{<cache>.*<prefix>.*</cache>}m))
    end

    it 'should write out the configuration with the full page cache backend being file' do
      expect(chef_run).to render_file(configuration_file)
        .with_content(match(%r{<full_page_cache>.*<backend><!\[CDATA\[file\]\]></backend>.*</full_page_cache>}m))
    end

    it 'should write out the configuration without redis full page cache settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content(match(%r{<full_page_cache>.*<backend_options>.*</full_page_cache>}m))
    end

    it 'should write out the configuration with the slow full page cache backend being database' do
      expect(chef_run).to render_file(configuration_file).with_content(
        match(%r{<full_page_cache>.*<slow_backend><!\[CDATA\[database\]\]></slow_backend>.*</full_page_cache>}m)
      )
    end

    it 'should write out the configuration without memcached full page cache settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content(match(%r{<full_page_cache>.*<memcached>.*</full_page_cache>}m))
    end

    it 'should write out the configuration without full page cache prefix settings' do
      expect(chef_run).to_not render_file(configuration_file)
        .with_content(match(%r{<full_page_cache>.*<prefix>.*</full_page_cache>}m))
    end

    it 'should write out the configuration with admin URI being admin' do
      expect(chef_run).to render_file(configuration_file)
        .with_content('<frontName><![CDATA[admin]]></frontName>')
    end
  end

  context 'with default attributes and no magento sites' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project1']['type'] = 'non-magento-site'
        node.set['nginx']['sites']['project1']['docroot'] = '/var/www/project1'
        node.set['apache']['sites']['project2']['type'] = 'non-magento-site'
        node.set['apache']['sites']['project2']['docroot'] = '/var/www/project2'
      end.converge(described_recipe)
    end

    it 'should not create a configuration directory' do
      expect(chef_run).to_not create_directory('/var/www/project1/app/etc')
      expect(chef_run).to_not create_directory('/var/www/project2/app/etc')
    end

    it 'should not create a configuration file' do
      expect(chef_run).to_not create_template('/var/www/project1/app/etc/local.xml')
      expect(chef_run).to_not create_template('/var/www/project2/app/etc/local.xml')
    end
  end

  context 'with default attributes and one site without crypt key' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['docroot'] = '/var/www/project/public'
      end.converge(described_recipe)
    end

    let(:error_message) do
      "You must set node['nginx']['sites']['project']['magento']['app']['crypt_key']"\
      " in chef-solo mode."
    end

    it 'should complain about the lack of crypt key when in chef solo mode' do
      expect { chef_run }.to raise_error(RuntimeError, error_message)
    end
  end

  context 'with default attributes and one site without capistrano' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['docroot'] = '/var/www/project/public'
        node.set['nginx']['sites']['project']['magento']['app']['crypt_key'] = 'I am a random string!'
      end.converge(described_recipe)
    end

    let(:configuration_file) { '/var/www/project/public/app/etc/local.xml' }

    it 'should create the configuration directory' do
      expect(chef_run).to create_directory('/var/www/project/public/app/etc')
    end

    it 'should create the configuration file' do
      expect(chef_run).to create_template(configuration_file)
        .with(source: 'magento-local.xml.erb', mode: 0644)
    end

    it_behaves_like 'default local.xml'
  end

  context 'with default attributes and one site with capistrano' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['capistrano']['deploy_to'] = '/var/www/project'
        node.set['nginx']['sites']['project']['magento']['app']['crypt_key'] = 'I am a random string!'
      end.converge(described_recipe)
    end

    let(:configuration_file) { '/var/www/project/shared/public/app/etc/local.xml' }

    it 'should create the configuration directory' do
      expect(chef_run).to create_directory('/var/www/project/shared/public/app/etc')
    end

    it 'should create the configuration file' do
      expect(chef_run).to create_template(configuration_file)
        .with(source: 'magento-local.xml.erb', mode: 0644)
    end

    it_behaves_like 'default local.xml'
  end

  context 'with default attributes, one site and parent directory exists' do
    before do
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?).with('/var/www/project/current/public/app/etc').and_return(true)
    end

    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['docroot'] = '/var/www/project/public'
        node.set['nginx']['sites']['project']['magento']['app']['crypt_key'] = 'I am a random string!'
      end.converge(described_recipe)
    end

    it 'should not create the configuration directory as it exists already' do
      expect(chef_run).to_not create_directory('/var/www/project/shared/public/app/etc')
    end

    it 'should create the configuration file' do
      expect(chef_run).to create_template('/var/www/project/public/app/etc/local.xml')
        .with(source: 'magento-local.xml.erb', mode: 0644)
    end
  end

  context 'with default attributes and two sites with capistrano' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project1']['type'] = 'magento'
        node.set['nginx']['sites']['project1']['capistrano']['deploy_to'] = '/var/www/project1'
        node.set['nginx']['sites']['project1']['magento']['app']['crypt_key'] = 'I am a random string!'
        node.set['nginx']['sites']['project2']['type'] = 'magento'
        node.set['nginx']['sites']['project2']['capistrano']['deploy_to'] = '/var/www/project2'
        node.set['nginx']['sites']['project2']['magento']['app']['crypt_key'] = 'I am a random string!'
      end.converge(described_recipe)
    end

    let(:configuration_file_project1) { '/var/www/project1/shared/public/app/etc/local.xml' }

    let(:configuration_file_project2) { '/var/www/project2/shared/public/app/etc/local.xml' }

    it 'should create the configuration directory for project 1' do
      expect(chef_run).to create_directory('/var/www/project1/shared/public/app/etc')
    end

    it 'should create the configuration file for project 1' do
      expect(chef_run).to create_template(configuration_file_project1)
        .with(source: 'magento-local.xml.erb', mode: 0644)
    end

    it_behaves_like 'default local.xml' do
      let(:configuration_file) { configuration_file_project1 }
    end

    it 'should create the configuration directory for project 2' do
      expect(chef_run).to create_directory('/var/www/project2/shared/public/app/etc')
    end

    it 'should create the configuration file for project 2' do
      expect(chef_run).to create_template(configuration_file_project2)
        .with(source: 'magento-local.xml.erb', mode: 0644)
    end

    it_behaves_like 'default local.xml' do
      let(:configuration_file) { configuration_file_project2 }
    end
  end

  context 'with non-default parameters' do
    let(:half_set_up_chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['nginx']['sites']['project']['type'] = 'magento'
        node.set['nginx']['sites']['project']['docroot'] = '/var/www/project/public'
        node.set['nginx']['sites']['project']['magento']['app']['crypt_key'] = 'I am a random string!'
      end
    end

    let(:configuration_file) { '/var/www/project/public/app/etc/local.xml' }

    context 'with environment' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['environment'] = 'test'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with the environment' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<environment><![CDATA[test]]></environment>')
      end
    end

    context 'with custom xml' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['magento']['global']['custom'] = '<test><![CDATA[Custom entry!]]></test>'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with the custom additional entries' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<test><![CDATA[Custom entry!]]></test>')
      end
    end

    context 'with additional extra parameters' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['magento']['global']['extra_params'] = {
          'hello' => 123,
          'hello_back' => 456
        }
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with the new extra parameters' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<hello><![CDATA[123]]></hello>')
        expect(chef_run).to render_file(configuration_file)
          .with_content('<hello_back><![CDATA[456]]></hello_back>')
      end
    end

    context 'with database table prefix' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['table_prefix'] = 'prefixed'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with a non-empty database table prefix' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<table_prefix><![CDATA[prefixed]]></table_prefix>')
      end
    end

    context 'with different default database configuration' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['host'] = '10.0.0.2'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['username'] = 'test_user'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['password'] = 'test_password'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['persistent'] = '1'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['active'] = '0'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['model'] = 'postgres'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['initStatements'] = ''
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db']['type'] = 'pdo_postgresql'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with the modified database setup' do
        expected = %r{
          <default_setup>.*
            <host>#{cdata_open}10.0.0.2#{cdata_close}</host>.*
            <dbname>#{cdata_open}magentodb#{cdata_close}</dbname>.*
            <username>#{cdata_open}test_user#{cdata_close}</username>.*
            <persistent>#{cdata_open}1#{cdata_close}</persistent>.*
            <active>#{cdata_open}0#{cdata_close}</active>.*
            <model>#{cdata_open}postgres#{cdata_close}</model>.*
            <initStatements>#{cdata_open}#{cdata_close}</initStatements>.*
            <type>#{cdata_open}pdo_postgresql#{cdata_close}</type>.*
            <password>#{cdata_open}test_password#{cdata_close}</password>.*
          </default_setup>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with additional database configuration' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db_connections']['read_database'] = {
          'name_override' => 'read_database_overridden',
          'host' => '10.0.0.3',
          'database' => 'magentodb_read',
          'persistent' => '1'
        }
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with a second database that inherits some settings from the first' do
        expected = %r{
          <read_database_overridden>.*
            <host>#{cdata_open}10.0.0.3#{cdata_close}</host>.*
            <dbname>#{cdata_open}magentodb_read#{cdata_close}</dbname>.*
            <username>#{cdata_open}magentouser#{cdata_close}</username>.*
            <persistent>#{cdata_open}1#{cdata_close}</persistent>.*
            <active>#{cdata_open}1#{cdata_close}</active>.*
            <model>#{cdata_open}mysql4#{cdata_close}</model>.*
            <initStatements>#{cdata_open}SET\sNAMES\sutf8#{cdata_close}</initStatements>.*
            <type>#{cdata_open}pdo_mysql#{cdata_close}</type>.*
          </read_database_overridden>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with additional database configuration that uses another' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['db_connections']['use_database'] = {
          'use' => 'some_other_connection'
        }
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with a second database that uses another database definition' do
        expected = %r{
          <use_database>.*
            <use>#{cdata_open}some_other_connection#{cdata_close}</use>.*
          </use_database>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with session save being default redis' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['multi_session_save'] = 'redis'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with session save being database' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<session_save><![CDATA[db]]></session_save>')
      end

      it 'should write out the configuration with redis session settings' do
        expected = %r{
          <redis_session>.*
            <host>#{cdata_open}127.0.0.1#{cdata_close}</host>.*
            <port>#{cdata_open}6379#{cdata_close}</port>.*
            <timeout>#{cdata_open}2.5#{cdata_close}</timeout>.*
            <db>#{cdata_open}2#{cdata_close}</db>.*
            <compression_threshold>#{cdata_open}2048#{cdata_close}</compression_threshold>.*
            <compression_lib>#{cdata_open}gzip#{cdata_close}</compression_lib>.*
          </redis_session>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with session save being custom redis' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['multi_session_save'] = 'redis'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['host'] = '10.0.0.4'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['port'] = '10240'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['timeout'] = '10'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['session_database'] = '11'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compress_threshold'] = '1024'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compression_lib'] = 'snappy'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with session save being database' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<session_save><![CDATA[db]]></session_save>')
      end

      it 'should write out the configuration with redis session settings' do
        expected = %r{
          <redis_session>.*
            <host>#{cdata_open}10.0.0.4#{cdata_close}</host>.*
            <port>#{cdata_open}10240#{cdata_close}</port>.*
            <timeout>#{cdata_open}10#{cdata_close}</timeout>.*
            <db>#{cdata_open}11#{cdata_close}</db>.*
            <compression_threshold>#{cdata_open}1024#{cdata_close}</compression_threshold>.*
            <compression_lib>#{cdata_open}snappy#{cdata_close}</compression_lib>.*
          </redis_session>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with session save being default memcached' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['multi_session_save'] = 'memcache'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with session save being memcache' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<session_save><![CDATA[memcache]]></session_save>')
      end

      it 'should write out the configuration with memcached session settings' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<session_save_path><![CDATA[tcp://127.0.0.1:11211?')
      end
    end

    context 'with session save being custom memcached' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['multi_session_save'] = 'memcache'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['session_memcache_ip'] = '10.0.0.5'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['session_memcache_port'] = '11311'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with session save being memcache' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<session_save><![CDATA[memcache]]></session_save>')
      end

      it 'should write out the configuration with memcached session settings' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<session_save_path><![CDATA[tcp://10.0.0.5:11311?')
      end
    end

    context 'with cache using default redis' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'Cm_Cache_Backend_Redis'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with cache backend being redis' do
        expect(chef_run).to render_file(configuration_file)
          .with_content(match(%r{<cache>.*<backend><!\[CDATA\[Cm_Cache_Backend_Redis\]\]></backend>.*</cache>}m))
      end

      it 'should write out the configuration with redis cache settings' do
        expected = %r{
          <cache>.*
            <backend_options>.*
              <server>#{cdata_open}127.0.0.1#{cdata_close}</server>.*
              <port>#{cdata_open}6379#{cdata_close}</port>.*
              <database>#{cdata_open}0#{cdata_close}</database>.*
              <force_standalone>#{cdata_open}0#{cdata_close}</force_standalone>.*
              <automatic_cleaning_factor>#{cdata_open}0#{cdata_close}</automatic_cleaning_factor>.*
              <compress_data>#{cdata_open}1#{cdata_close}</compress_data>.*
              <compress_tags>#{cdata_open}1#{cdata_close}</compress_tags>.*
              <compress_threshold>#{cdata_open}2048#{cdata_close}</compress_threshold>.*
              <compression_lib>#{cdata_open}gzip#{cdata_close}</compression_lib>.*
            </backend_options>.*
          </cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with cache using custom redis' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'Cm_Cache_Backend_Redis'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['host'] = '10.0.0.6'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['port'] = '10241'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['database'] = '19'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['force_standalone'] = '1'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['automatic_cleaning_factor'] = '10'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compress_data'] = '0'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compress_tags'] = '0'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compress_threshold'] = '512'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compression_lib'] = 'lzf'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with cache backend being redis' do
        expect(chef_run).to render_file(configuration_file)
          .with_content(match(%r{<cache>.*<backend><!\[CDATA\[Cm_Cache_Backend_Redis\]\]></backend>.*</cache>}m))
      end

      it 'should write out the configuration with redis cache settings' do
        expected = %r{
          <cache>.*
            <backend_options>.*
              <server>#{cdata_open}10.0.0.6#{cdata_close}</server>.*
              <port>#{cdata_open}10241#{cdata_close}</port>.*
              <database>#{cdata_open}19#{cdata_close}</database>.*
              <force_standalone>#{cdata_open}1#{cdata_close}</force_standalone>.*
              <automatic_cleaning_factor>#{cdata_open}10#{cdata_close}</automatic_cleaning_factor>.*
              <compress_data>#{cdata_open}0#{cdata_close}</compress_data>.*
              <compress_tags>#{cdata_open}0#{cdata_close}</compress_tags>.*
              <compress_threshold>#{cdata_open}512#{cdata_close}</compress_threshold>.*
              <compression_lib>#{cdata_open}lzf#{cdata_close}</compression_lib>.*
            </backend_options>.*
          </cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with cache using default memcached' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'memcached'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with cache backend being memcached' do
        expect(chef_run).to render_file(configuration_file)
          .with_content(match(%r{<cache>.*<backend><!\[CDATA\[memcached\]\]></backend>.*</cache>}m))
      end

      it 'should write out the configuration with memcached cache settings and no servers' do
        expected = %r{
          <cache>.*
            <memcached>.*
              <servers><!--[a-zA-Z\s]*-->\s*</servers>.*
            </memcached>.*
          </cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with cache using custom memcached' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'memcached'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_servers'] = [
          {
            :host => '10.0.0.7',
            :port => '11211',
            :persistent => '1',
            :weight => '11',
            :timeout => '2',
            :retry_interval => '10',
            :status => '1'
          }
        ]
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with cache backend being memcached' do
        expect(chef_run).to render_file(configuration_file)
          .with_content(match(%r{<cache>.*<backend><!\[CDATA\[memcached\]\]></backend>.*</cache>}m))
      end

      it 'should write out the configuration with memcached cache settings' do
        expected = %r{
          <cache>.*
            <memcached>.*
              <servers>.*
                <server>.*
                  <host>#{cdata_open}10.0.0.7#{cdata_close}</host>.*
                  <port>#{cdata_open}11211#{cdata_close}</port>.*
                  <persistent>#{cdata_open}1#{cdata_close}</persistent>.*
                  <weight>#{cdata_open}11#{cdata_close}</weight>.*
                  <timeout>#{cdata_open}2#{cdata_close}</timeout>.*
                  <retry_interval>#{cdata_open}10#{cdata_close}</retry_interval>.*
                  <status>#{cdata_open}1#{cdata_close}</status>.*
                </server>\s*
              </servers>.*
            </memcached>.*
          </cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with cache prefix' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['cache_prefix'] = 'cache_'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with the given cache prefix' do
        expect(chef_run).to render_file(configuration_file).with_content(
          match(%r{<cache>.*<prefix>#{cdata_open}cache_#{cdata_close}</prefix>.*</cache>}m)
        )
      end
    end

    context 'with full page cache using default redis' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'Cm_Cache_Backend_Redis'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with full page cache backend being redis' do
        expect(chef_run).to render_file(configuration_file).with_content(
          match(%r{<full_page_cache>.*<backend><!\[CDATA\[Cm_Cache_Backend_Redis\]\]></backend>.*</full_page_cache>}m)
        )
      end

      it 'should write out the configuration with full page redis cache settings' do
        expected = %r{
          <full_page_cache>.*
            <backend_options>.*
              <server>#{cdata_open}127.0.0.1#{cdata_close}</server>.*
              <port>#{cdata_open}6379#{cdata_close}</port>.*
              <database>#{cdata_open}1#{cdata_close}</database>.*
              <force_standalone>#{cdata_open}0#{cdata_close}</force_standalone>.*
              <automatic_cleaning_factor>#{cdata_open}0#{cdata_close}</automatic_cleaning_factor>.*
              <compress_data>#{cdata_open}1#{cdata_close}</compress_data>.*
              <compress_tags>#{cdata_open}1#{cdata_close}</compress_tags>.*
              <compress_threshold>#{cdata_open}2048#{cdata_close}</compress_threshold>.*
              <compression_lib>#{cdata_open}gzip#{cdata_close}</compression_lib>.*
            </backend_options>.*
          </full_page_cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with full page cache using custom redis' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'Cm_Cache_Backend_Redis'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['host'] = '10.0.0.6'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['port'] = '10241'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['full_page_cache_database'] = '20'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['force_standalone'] = '1'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['automatic_cleaning_factor'] = '10'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compress_data'] = '0'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compress_tags'] = '0'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compress_threshold'] = '512'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['redis']['compression_lib'] = 'lzf'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with full page cache backend being redis' do
        expect(chef_run).to render_file(configuration_file)
          .with_content(match(%r{<full_page_cache>.*<backend><!\[CDATA\[Cm_Cache_Backend_Redis\]\]></backend>.*</full_page_cache>}m))
      end

      it 'should write out the configuration with redis full page cache settings' do
        expected = %r{
          <full_page_cache>.*
            <backend_options>.*
              <server>#{cdata_open}10.0.0.6#{cdata_close}</server>.*
              <port>#{cdata_open}10241#{cdata_close}</port>.*
              <database>#{cdata_open}20#{cdata_close}</database>.*
              <force_standalone>#{cdata_open}1#{cdata_close}</force_standalone>.*
              <automatic_cleaning_factor>#{cdata_open}10#{cdata_close}</automatic_cleaning_factor>.*
              <compress_data>#{cdata_open}0#{cdata_close}</compress_data>.*
              <compress_tags>#{cdata_open}0#{cdata_close}</compress_tags>.*
              <compress_threshold>#{cdata_open}512#{cdata_close}</compress_threshold>.*
              <compression_lib>#{cdata_open}lzf#{cdata_close}</compression_lib>.*
            </backend_options>.*
          </full_page_cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with full page cache using default memcached' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'memcached'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with full page cache backend being memcached' do
        expect(chef_run).to render_file(configuration_file)
          .with_content(match(%r{<full_page_cache>.*<backend><!\[CDATA\[memcached\]\]></backend>.*</full_page_cache>}m))
      end

      it 'should write out the configuration with memcached full page cache settings and no servers' do
        expected = %r{
          <full_page_cache>.*
            <memcached>.*
              <servers><!--[a-zA-Z\s]*-->\s*</servers>.*
            </memcached>.*
          </full_page_cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with full page cache using custom memcached' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_cache'] = 'memcached'
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['backend_servers'] = [
          {
            :host => '10.0.0.7',
            :port => '11211',
            :persistent => '1',
            :weight => '11',
            :timeout => '2',
            :retry_interval => '10',
            :status => '1'
          }
        ]
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with full page cache backend being memcached' do
        expect(chef_run).to render_file(configuration_file)
          .with_content(match(%r{<full_page_cache>.*<backend><!\[CDATA\[memcached\]\]></backend>.*</full_page_cache>}m))
      end

      it 'should write out the configuration with memcached full page cache settings' do
        expected = %r{
          <full_page_cache>.*
            <memcached>.*
              <servers>.*
                <server>.*
                  <host>#{cdata_open}10.0.0.7#{cdata_close}</host>.*
                  <port>#{cdata_open}11211#{cdata_close}</port>.*
                  <persistent>#{cdata_open}1#{cdata_close}</persistent>.*
                  <weight>#{cdata_open}11#{cdata_close}</weight>.*
                  <timeout>#{cdata_open}2#{cdata_close}</timeout>.*
                  <retry_interval>#{cdata_open}10#{cdata_close}</retry_interval>.*
                  <status>#{cdata_open}1#{cdata_close}</status>.*
                </server>\s*
              </servers>.*
            </memcached>.*
          </full_page_cache>
        }mx
        expect(chef_run).to render_file(configuration_file).with_content(match(expected))
      end
    end

    context 'with full page cache prefix' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['fpc_prefix'] = 'fpc'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with the given full page cache prefix' do
        expect(chef_run).to render_file(configuration_file).with_content(
          match(%r{<full_page_cache>.*<prefix>#{cdata_open}fpc#{cdata_close}</prefix>.*</full_page_cache>}m)
        )
      end
    end

    context 'with admin URI' do
      cached(:chef_run) do
        half_set_up_chef_run.dup
        half_set_up_chef_run.node.set['nginx']['sites']['project']['magento']['app']['admin_frontname'] = 'super-secret'
        half_set_up_chef_run.converge(described_recipe)
      end

      it 'should write out the configuration with the given admin URI' do
        expect(chef_run).to render_file(configuration_file)
          .with_content('<frontName><![CDATA[super-secret]]></frontName>')
      end
    end
  end
end

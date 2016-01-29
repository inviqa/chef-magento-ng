magento-ng-cookbook
===================

A collection of recipes to prepare environments for hosting Magento applications.

## Supported Platforms

TBC...

Recipes
-------

### magento-ng::cron

Sets up the system cron to call the Magento cron executor for each defined Magento site.

### magento-ng::etc-local

Prepared the local.xml file for each defined Magento site.

### magento-ng::stack

Set up a complete Magento application server calling many of the other magento-ng recipes.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['magento']['db']['host']</tt></td>
    <td>String</td>
    <td>Database host name / IP</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['database']</tt></td>
    <td>String</td>
    <td>Database name</td>
    <td><tt>magentodb</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['username']</tt></td>
    <td>String</td>
    <td>Database user name</td>
    <td><tt>magentouser</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['password']</tt></td>
    <td>String</td>
    <td>Database user password</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['persistant']</tt></td>
    <td>String</td>
    <td>Use persistent connections</td>
    <td><tt>0</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['active']</tt></td>
    <td>String</td>
    <td>Is the database active</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['model']</tt></td>
    <td>String</td>
    <td>Database type</td>
    <td><tt>mysql4</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['initStatements']</tt></td>
    <td>String</td>
    <td>Database init statements</td>
    <td><tt>SET NAMES utf8</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['db']['type']</tt></td>
    <td>String</td>
    <td>PHP database driver</td>
    <td><tt>pdo_mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['base_path']</tt></td>
    <td>String</td>
    <td>Path to the root of the Magento files</td>
    <td><tt>public</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['locale']</tt></td>
    <td>String</td>
    <td>Default locale</td>
    <td><tt>en_GB</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['timezone']</tt></td>
    <td>String</td>
    <td>Default timezone</td>
    <td><tt>Europe/London</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['currency']</tt></td>
    <td>String</td>
    <td>Default currency</td>
    <td><tt>GBP</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['session_save']</tt></td>
    <td>String</td>
    <td>Session storage type (files|db|memcache)</td>
    <td><tt>db</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['admin_frontname']</tt></td>
    <td>String</td>
    <td>URL path to the admin</td>
    <td><tt>admin</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['use_rewrites']</tt></td>
    <td>String</td>
    <td>Whether to use URL rewriting</td>
    <td><tt>yes</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['use_secure']</tt></td>
    <td>String</td>
    <td>Allow secure connections</td>
    <td><tt>yes</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['use_secure_admin']</tt></td>
    <td>String</td>
    <td>Allow secure connections to admin</td>
    <td><tt>yes</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['multi_session_save']</tt></td>
    <td>String</td>
    <td>Multi session storage type (files|db|memcache)</td>
    <td><tt>db</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['session_memcache_ip']</tt></td>
    <td>String</td>
    <td>IP of session storage memcache instance</td>
    <td><tt>127.0.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['session_memcache_port']</tt></td>
    <td>String</td>
    <td>Port to connect to session storage memcache</td>
    <td><tt>11211</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['backend_cache']</tt></td>
    <td>String</td>
    <td>Cache storage type (apc|memcache|xcache|file|CM_Cache_Backend_Redis)</td>
    <td><tt>file</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['app']['slow_backend']</tt></td>
    <td>String</td>
    <td>Slow cache storage type (database|file)</td>
    <td><tt>database</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['host']</tt></td>
    <td>String</td>
    <td>Hostnane/IP of the Redis instance</td>
    <td><tt>127.0.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['port']</tt></td>
    <td>String</td>
    <td>Redis instance port</td>
    <td><tt>6379</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['timeout']</tt></td>
    <td>String</td>
    <td>Redis connection timeout</td>
    <td><tt>2.5</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['database']</tt></td>
    <td>String</td>
    <td>Database to use for backend cache</td>
    <td><tt>0</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['full_page_cache_database']</tt></td>
    <td>String</td>
    <td>Database to use for full page cache</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['session_database']</tt></td>
    <td>String</td>
    <td>Database to use for session storage</td>
    <td><tt>2</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['force_standalone']</tt></td>
    <td>String</td>
    <td>Enforce standalone PHP redis, 0 for phpredis</td>
    <td><tt>0</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['automatic_cleaning_factor']</tt></td>
    <td>String</td>
    <td>Enable automatic cleaning (not recommended)</td>
    <td><tt>0</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['compress_data']</tt></td>
    <td>String</td>
    <td>Enable data compression</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['compress_tags']</tt></td>
    <td>String</td>
    <td>Enable tag compression</td>
    <td><tt>1</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['compress_threshold']</tt></td>
    <td>String</td>
    <td>Minimum string size for compression</td>
    <td><tt>2040</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['redis']['compression_lib']</tt></td>
    <td>String</td>
    <td>Compression library (gzip|lzf|l4z|snappy)</td>
    <td><tt>gzip</tt></td>
  </tr>
  <tr>
    <td><tt>['magento']['global']['extra_params']</tt></td>
    <td>Object</td>
    <td>Key/value parameter pairs</td>
    <td><tt>
      {
        'skip_process_modules_updates' => 1,
        'skip_process_modules_updates_dev_mode' => 1
      }
    </tt></td>
  </tr>
</table>

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Supermarket share
-----------------

[stove](http://sethvargo.github.io/stove/) is used to create git tags and
publish the cookbook on supermarket.chef.io.

To tag/publish you need to be a contributor to the cookbook on Supermarket and
run:

```
$ stove login --username <your username> --key ~/.chef/<your username>.pem
$ rake publish
```

It will take the version defined in metadata.rb, create a tag, and push the
cookbook to http://supermarket.chef.io/cookbooks/magento-ng


License and Authors
-------------------
- Author:: Andy Thompson

```text
Copyright:: 2015 Inviqa UK LTD

See LICENSE file
```

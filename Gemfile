source 'https://rubygems.org'

gem 'berkshelf', '~> 4.3'
gem 'chef', '~> 12.5'
gem 'rake', '~> 11.1'

group :cookbook_dependencies do
  gem 'aws-sdk', '~> 2.0'
end

group :integration do
  gem 'kitchen-vagrant', '~> 0.20'
  gem 'test-kitchen', '~> 1.7'
end

group :test do
  gem 'chefspec', '~> 7.2'
  gem 'foodcritic', '~> 6.2'
  gem 'rubocop', '~> 0.55'
end

group :deployment do
  gem 'stove', '~> 3.2.7'
end

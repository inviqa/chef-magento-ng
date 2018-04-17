require 'chefspec'
require 'chefspec/berkshelf'

unless defined? Gem::MissingSpecError
  module Gem
    class MissingSpecError
    end
  end
end

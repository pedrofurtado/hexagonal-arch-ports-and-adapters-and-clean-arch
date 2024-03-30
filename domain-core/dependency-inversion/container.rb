require 'singleton'

module DomainCore
  module DependencyInversion
    class Container
      include Singleton

      def register(key, value)
        @registries ||= {}
        @registries[key] = value
      end

      def get(key)
        @registries[key].new
      end
    end
  end
end

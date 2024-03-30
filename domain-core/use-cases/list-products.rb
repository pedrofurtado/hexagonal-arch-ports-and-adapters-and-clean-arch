module DomainCore
  module UseCases
    class ListProducts
      def initialize(&block)
        @callbacks = CallbackHandlers.new
        yield(@callbacks)
      end

      def execute
        products_repository = DomainCore::DependencyInversion::Container.instance.get('products_repository')

        begin
          @callbacks.on_success_handler(products_repository.list_all)
        rescue => e
          @callbacks.on_failure_handler(e)
        end
      end
    end
  end
end

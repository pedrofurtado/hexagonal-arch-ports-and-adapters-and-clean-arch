module DomainCore
  module UseCases
    class ListProducts
      def initialize(&block)
        @callbacks = CallbackHandlers.new
        yield(@callbacks)
      end

      def execute(list_product_dto)
        products_repository = DomainCore::DependencyInversion::Container.instance.get('products_repository')
        products_presenter = DomainCore::DependencyInversion::Container.instance.get('products_presenter')
        list_products_validator = DomainCore::DependencyInversion::Container.instance.get('list_products_validator')

        begin
          list_products_validator.validate!(list_product_dto)
          list_product_output_dto = DomainCore::Dtos::ListProductOutputDto.new
          list_product_output_dto.products = products_repository.list_all(list_product_dto)
          @callbacks.on_success_handler(products_presenter.from(list_product_output_dto))
        rescue => e
          @callbacks.on_failure_handler(e)
        end
      end
    end
  end
end

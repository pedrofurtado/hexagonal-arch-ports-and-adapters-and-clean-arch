module DomainCore
  module Validators
    class ListProduct
      def validate!(list_product_dto)
        raise 'ID must not be less than 1' if list_product_dto.id && list_product_dto.id.to_i < 1
        raise 'Filter by status "blocked" is not allowed' if list_product_dto.situation && list_product_dto.situation == 'blocked'
      end
    end
  end
end

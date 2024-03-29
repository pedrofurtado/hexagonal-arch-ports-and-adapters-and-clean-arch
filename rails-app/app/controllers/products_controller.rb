require '/app/domain_core.rb'

class ProductsController < ActionController::API
  def index
    list_products_use_case = DomainCore::UseCases::ListProducts.new do |callbacks|
      callbacks.on_success = Proc.new do |products_records_list|
        payload = products_records_list.map do |product_record|
          {
            Id: product_record.id,
            Name: product_record.name,
            Situation: product_record.status
          }
        end

        render json: payload, status: 200
      end

      callbacks.on_failure = Proc.new do |error|
        render json: { error: error.message }, status: 500
      end
    end

    list_products_use_case.execute()
  end
end

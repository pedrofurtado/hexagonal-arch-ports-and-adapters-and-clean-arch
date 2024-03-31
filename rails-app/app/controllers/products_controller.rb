require '/app/domain-core/all'

class ProductsController < ActionController::API
  def index
    list_products_use_case = DomainCore::UseCases::ListProducts.new do |callbacks|
      callbacks.on_success = Proc.new do |products_presenter|
        render json: products_presenter.convert_to_json, status: 200
      end

      callbacks.on_failure = Proc.new do |error|
        render json: { error: error.message }, status: 500
      end
    end

    dto = DomainCore::Dtos::ListProductInputDto.new
    dto.id = request.query_parameters['id']
    dto.situation = request.query_parameters['situation']

    list_products_use_case.execute(dto)
  end
end

require 'sinatra'
require 'sinatra/reloader'

require '/app/domain-core/all'

configure do
  enable :reloader
  set :strict_paths, false
end

get '/products' do
  content_type 'text/plain'

  list_products_use_case = DomainCore::UseCases::ListProducts.new do |callbacks|
    callbacks.on_success = Proc.new do |products_presenter|
      products_presenter.convert_to_xml
    end

    callbacks.on_failure = Proc.new do |error|
      status 501
      XmlSimple.xml_out({ fail: error.message }, {:keeproot => true, :noescape => true})
    end
  end

  dto = DomainCore::Dtos::ListProductInputDto.new
  dto.id = params[:id]
  dto.situation = params[:situation]

  list_products_use_case.execute(dto)
end

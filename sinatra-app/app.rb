require 'sinatra'
require 'sinatra/reloader'

require '/app/domain_core.rb'

configure do
  enable :reloader
  set :strict_paths, false
end

get '/products' do
  content_type :json

  list_products_use_case = DomainCore::UseCases::ListProducts.new do |callbacks|
    callbacks.on_success = Proc.new do |products_records_list|
      payload = products_records_list.map do |product_record|
        {
          Codigo: product_record.id,
          Nome: product_record.name,
          Situacao: product_record.status
        }
      end

      { results: payload }.to_json
    end

    callbacks.on_failure = Proc.new do |error|
      status 501
      { fail: error.message }.to_json
    end
  end

  list_products_use_case.execute()
end

#domain core
require 'ostruct'
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

module DomainCore
  module DatabaseAdapters
    class SQLite
      def list_all_products
        success = false
        if success
          [{ 'identifier' => '10', 'full_name' => 'Shoes', 'state' => 'in_sale' }, { 'identifier' => '28', 'full_name' => 'T-shirt', 'state' => 'in_preparation' }]
        else
          raise StandardError.new('error on database, sqlite crashed!')
        end
      end
    end

    class Postgres
      def list_all_products
        success = true
        if success
          [{ 'identifier' => '40', 'full_name' => 'Headphone bluetooth', 'state' => 'selled' }]
        else
          raise StandardError.new('error on database, postgres crashed!')
        end
      end
    end

    class Mysql
      def list_all_products
        success = false
        if success
          [{ 'identifier' => '8', 'full_name' => 'Water glass', 'state' => 'ready' }, { 'identifier' => '96', 'full_name' => 'Orange juice', 'state' => 'cold' }, { 'identifier' => '3', 'full_name' => 'Dell notebook', 'state' => 'installed' }]
        else
          raise StandardError.new('error on database, mysql crashed!')
        end
      end
    end
  end
end

module DomainCore
  module Repositories
    class ProductRecord
      attr_accessor :id, :name, :status
    end

    class Product
      def list_all
        database_adapter = DomainCore::DependencyInversion::Container.instance.get('database_adapter')
        items_from_db = database_adapter.list_all_products

        product_records_list = []

        items_from_db.each do |item_from_db|
          product_record = ProductRecord.new

          product_record.id = item_from_db['identifier']
          product_record.name = item_from_db['full_name']
          product_record.status = item_from_db['state']

          product_records_list << product_record
        end

        product_records_list
      end
    end
  end
end

module DomainCore
  module UseCases
    class CallbackHandlers
      attr_accessor :on_success, :on_failure

      def on_success_handler(result)
        on_success.call(result)
      end

      def on_failure_handler(result)
        on_failure.call(result)
      end
    end

    class ListProducts
      def initialize(&block)
        @callbacks = CallbackHandlers.new
        yield(@callbacks)
      end

      def execute
        products_repository = DomainCore::DependencyInversion::Container.instance.get('products_repository')

        begin
          #
          @callbacks.on_success_handler(products_repository.list_all)
        rescue => e
          #OpenStruct.new(message: 'error very crazy, broked!')
          @callbacks.on_failure_handler(e)
        end
      end
    end
  end
end

#initializers
DomainCore::DependencyInversion::Container.instance.register('products_repository', DomainCore::Repositories::Product)
DomainCore::DependencyInversion::Container.instance.register('database_adapter', DomainCore::DatabaseAdapters::Postgres)

# inside rails app
class ProductsController < ActionController::API
  def index
    list_products_use_case = DomainCore::UseCases::ListProducts.new do |callbacks|
      callbacks.on_success = Proc.new do |products|
        payload = products.map do |product|
          {
            Id: product.id,
            Name: product.name,
            Situation: product.status
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

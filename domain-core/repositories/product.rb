module DomainCore
  module Repositories
    class Product
      def list_all
        database_adapter = DomainCore::DependencyInversion::Container.instance.get('database_adapter')
        items_from_db = database_adapter.list_all_products

        product_records_list = []

        items_from_db.each do |item_from_db|
          product_record = ProductRecord.new

          product_record.id = item_from_db['identifier']
          product_record.name = item_from_db['full_name']
          product_record.status = item_from_db['state_name']

          product_records_list << product_record
        end

        product_records_list
      end
    end
  end
end

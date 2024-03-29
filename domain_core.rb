#domain core
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
    class Credentials
      def credentials
        {
          host:     ENV.fetch('DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_HOST'),
          username: ENV.fetch('DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_USER'),
          password: ENV.fetch('DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_PASSWORD'),
          database: ENV.fetch('DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_DB_NAME')
        }
      end
    end
  end
end

require "sqlite3"
module DomainCore
  module DatabaseAdapters
    class SQLite
      def list_all_products
        db = SQLite3::Database.new "/app/my_db.sqlite3"
        db.results_as_hash = true
        sql_commands = File.read('/app/initdb.sql')
        db.execute_batch sql_commands
        db.execute("SELECT * FROM products")
      end
    end
  end
end

require "pg"
module DomainCore
  module DatabaseAdapters
    class Postgres
      def list_all_products
        credentials = DomainCore::DependencyInversion::Container.instance.get('database_adapter_credentials').credentials

        client = PG.connect(
          host: credentials[:host],
          dbname: credentials[:database],
          user: credentials[:username],
          password: credentials[:password]
        )

        data_from_db = client.query("SELECT * FROM products")

        client.close

        data_from_db
      end
    end
  end
end

require "mysql2"
module DomainCore
  module DatabaseAdapters
    class Mysql
      def list_all_products
        credentials = DomainCore::DependencyInversion::Container.instance.get('database_adapter_credentials').credentials

        mysql_client = Mysql2::Client.new(
          connect_timeout: 3,
          host: credentials[:host],
          username: credentials[:username],
          password: credentials[:password],
          database: credentials[:database]
        )

        data_from_db = mysql_client.query("SELECT * FROM products", as: :hash).to_a
        mysql_client.close

        data_from_db
      end
    end
  end
end

module DomainCore
  module Repositories
    class ProductRecord
      attr_accessor :id, :name, :status
    end
  end
end

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
  end
end

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

#######initializers

# [CHANGE ONLY HERE]
db_adapter = 'sqlite' # mysql | postgres | sqlite

db_adapter_class = nil
case db_adapter
when 'mysql'
  ENV['DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_HOST'] = 'db_in_mysql'
  db_adapter_class = DomainCore::DatabaseAdapters::Mysql
when 'postgres'
  ENV['DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_HOST'] = 'db_in_postgres'
  db_adapter_class = DomainCore::DatabaseAdapters::Postgres
when 'sqlite'
  ENV['DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_HOST'] = '/app/my_db.sqlite3'
  db_adapter_class = DomainCore::DatabaseAdapters::SQLite
end

#shared credentials in all databases adapters
ENV['DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_USER'] = 'my_db_user'
ENV['DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_PASSWORD'] = 'my_db_password'
ENV['DOMAIN_CORE_DATABASE_ADAPTERS_CREDENTIALS_DB_NAME'] = 'my_db'

DomainCore::DependencyInversion::Container.instance.register('products_repository', DomainCore::Repositories::Product)
DomainCore::DependencyInversion::Container.instance.register('database_adapter', db_adapter_class)
DomainCore::DependencyInversion::Container.instance.register('database_adapter_credentials', DomainCore::DatabaseAdapters::Credentials)

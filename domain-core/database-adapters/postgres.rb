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

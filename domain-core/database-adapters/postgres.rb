require "pg"

module DomainCore
  module DatabaseAdapters
    class Postgres
      def list_all_products(list_product_dto)
        credentials = DomainCore::DependencyInversion::Container.instance.get('database_adapter_credentials').credentials

        client = PG.connect(
          host: credentials[:host],
          dbname: credentials[:database],
          user: credentials[:username],
          password: credentials[:password]
        )

        where_clauses = nil

        if list_product_dto.id
          where_clauses ||= 'WHERE 1=1'
          where_clauses += " AND identifier = #{list_product_dto.id}"
        end

        if list_product_dto.situation
          where_clauses ||= 'WHERE 1=1'
          where_clauses += " AND state_name = '#{list_product_dto.situation}'"
        end

        data_from_db = client.query("SELECT * FROM products #{where_clauses}")

        client.close

        data_from_db
      end
    end
  end
end

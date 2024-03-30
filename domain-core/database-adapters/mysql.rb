require "mysql2"

module DomainCore
  module DatabaseAdapters
    class Mysql
      def list_all_products(list_product_dto)
        credentials = DomainCore::DependencyInversion::Container.instance.get('database_adapter_credentials').credentials

        mysql_client = Mysql2::Client.new(
          connect_timeout: 3,
          host: credentials[:host],
          username: credentials[:username],
          password: credentials[:password],
          database: credentials[:database]
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

        data_from_db = mysql_client.query("SELECT * FROM products #{where_clauses}", as: :hash).to_a
        mysql_client.close

        data_from_db
      end
    end
  end
end

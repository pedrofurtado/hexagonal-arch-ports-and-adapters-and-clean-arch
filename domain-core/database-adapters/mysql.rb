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

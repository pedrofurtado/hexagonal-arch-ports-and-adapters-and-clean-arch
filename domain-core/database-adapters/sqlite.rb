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

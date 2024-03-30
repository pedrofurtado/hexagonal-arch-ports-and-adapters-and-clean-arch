require "sqlite3"

module DomainCore
  module DatabaseAdapters
    class SQLite
      def list_all_products(list_product_dto)
        db = SQLite3::Database.new "/app/my_db.sqlite3"
        db.results_as_hash = true
        sql_commands = File.read('/app/initdb.sql')
        db.execute_batch sql_commands

        where_clauses = nil

        if list_product_dto.id
          where_clauses ||= 'WHERE 1=1'
          where_clauses += " AND identifier = #{list_product_dto.id}"
        end

        if list_product_dto.situation
          where_clauses ||= 'WHERE 1=1'
          where_clauses += " AND state_name = '#{list_product_dto.situation}'"
        end

        db.execute("SELECT * FROM products #{where_clauses}")
      end
    end
  end
end

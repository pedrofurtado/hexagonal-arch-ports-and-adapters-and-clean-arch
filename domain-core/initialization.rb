# [CHANGE ONLY HERE]
db_adapter = 'mysql' # mysql | postgres | sqlite

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
DomainCore::DependencyInversion::Container.instance.register('list_products_validator', DomainCore::Validators::ListProduct)

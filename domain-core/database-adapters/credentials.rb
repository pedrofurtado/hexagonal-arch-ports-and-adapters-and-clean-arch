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

require_relative 'dependency-inversion/container'

require_relative 'database-adapters/credentials'
require_relative 'database-adapters/sqlite'
require_relative 'database-adapters/postgres'
require_relative 'database-adapters/mysql'

require_relative 'repositories/product-record'
require_relative 'repositories/product'

require_relative 'use-cases/callback-handlers'
require_relative 'use-cases/list-products'

require_relative 'dtos/list-product-input-dto'
require_relative 'dtos/list-product-output-dto'

require_relative 'validators/list-product'

require_relative 'presenters/product'

require_relative 'initialization'

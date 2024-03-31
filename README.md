# Hexagonal arch (Ports and adapters) and Clean arch

Clean Arch Flow

```
Rails app -> controller -> use case (with input dto) -> repository -> validators/repositories -> adapters (database, etc.)
                                                                                                      |
                                                                                                      |
             controller <-      json format          <-       presenter        <- output dto  <- adapters (database, etc.)


Sinatra app -> controller -> use case (with input dto) -> repository -> validators/repositories -> adapters (database, etc.)
                                                                                                      |
                                                                                                      |
               controller <-      xml format         <-       presenter        <- output dto    <- adapters (database, etc.)


CLI app -> command -> use case (with input dto) -> repository -> validators/repositories -> adapters (database, etc.)
                                                                                                      |
                                                                                                      |
           command <-  ascii terminal table format     <-   presenter   <- output dto    <- adapters (database, etc.)
```

```bash
#docker environment
docker-compose up --build -d

#connect to container bash
docker container exec -it hexagonal-arch-ports-and-adapters-and-clean-arch_ruby-environment_1 /bin/bash

#rails app (inside bash)
# access GET http://localhost:3000/products
# access GET http://localhost:3000/products?id=1
# access GET http://localhost:3000/products?situation=ready
# access GET http://localhost:3000/products?id=1&situation=ready
cd /app/rails-app/ && rm -Rf tmp/pids/server.pid && bundle install && bin/rails server -b 0.0.0.0 -p 3000

# sinatra app (inside bash)
# access GET http://localhost:3001/products
# access GET http://localhost:3001/products?id=1
# access GET http://localhost:3001/products?situation=ready
# access GET http://localhost:3001/products?id=1&situation=ready
cd /app/sinatra-app/ && bundle install && bundle exec rackup --host 0.0.0.0 --port 3001

# thor/cli app (inside bash)
  # show all comands
  cd /app/cli-app/ && bundle install && ruby ./cli
  # hello command
  cd /app/cli-app/ && bundle install && ruby ./cli hello John
  # list_all_products command
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products --id 1
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products --situation ready
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products --id 1 --situation ready
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products --id 11 --situation blabla
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products --id -5
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products --situation blocked
  # invalid command
  cd /app/cli-app/ && bundle install && ruby ./cli blabla
```


URL for reference: https://jmgarridopaz.github.io/content/hexagonalarchitecture.html

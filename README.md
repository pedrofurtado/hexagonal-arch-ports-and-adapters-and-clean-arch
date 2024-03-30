# Hexagonal arch (Ports and adapters) and Clean arch

```bash
#docker environment
docker-compose up --build -d

#connect to container bash
docker container exec -it hexagonal-arch-ports-and-adapters-and-clean-arch_ruby-environment_1 /bin/bash

#rails app (inside bash)
# access GET http://localhost:3000/products
cd /app/rails-app/ && rm -Rf tmp/pids/server.pid && bundle install && bin/rails server -b 0.0.0.0 -p 3000

# sinatra app (inside bash)
# access GET http://localhost:3001/products
cd /app/sinatra-app/ && bundle install && bundle exec rackup --host 0.0.0.0 --port 3001

# thor/cli app (inside bash)
  # show all comands
  cd /app/cli-app/ && bundle install && ruby ./cli
  # hello command
  cd /app/cli-app/ && bundle install && ruby ./cli hello John
  # list_all_products command
  cd /app/cli-app/ && bundle install && ruby ./cli list_all_products
  # invalid command
  cd /app/cli-app/ && bundle install && ruby ./cli blabla
```

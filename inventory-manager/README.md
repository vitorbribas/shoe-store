# README

## Dependencies:
- Ruby >= 3.1.4
- Docker

## Starting the application:

1. Initiate services with: `docker-compose up -d`

2. Run database setup: `rails db:setup`

3. On parent directory *shoe-store* start de websocket server: `bin/websocketd --port=8080 ruby inventory.rb`

3. Run this *inventory-manager* application: `rails consume_events:start`

4. Access [localhost:8025](localhost:8025) to observe the simulation of sending emails to customers.

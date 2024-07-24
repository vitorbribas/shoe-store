require 'faye/websocket'
require 'eventmachine'
require 'json'

module Services
  class EventsConsumer
    EVENTS_URL = ENV.fetch('EVENTS_URL', nil)

    class << self
      def start
        EM.run do
          ws = Faye::WebSocket::Client.new(EVENTS_URL)

          ws.on :open do |event|
            logger.info("Connected to WebSocket server on #{EVENTS_URL}")
          end

          ws.on :message do |event|
            data = JSON.parse(event.data, symbolize_names: true)
            save_event(data)
          end

          ws.on :close do |event|
            logger.info("Disconnected from WebSocket server")
            EM.stop
          end
        end
      end

      private

      def save_event(data)
        store = Store.find_or_create_by(name: data.dig(:store))
        model = Model.find_or_create_by(name: data.dig(:model))

        inventory = store.inventories.create(model:, amount: data.dig(:inventory))

        logger.info("Store: #{inventory.attributes}")
      end

      def logger
        @logger ||= Logger.new($stderr)
      end
    end
  end
end
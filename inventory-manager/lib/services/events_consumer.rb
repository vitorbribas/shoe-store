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
            puts "Connected to WebSocket server"
          end

          ws.on :message do |event|
            data = JSON.parse(event.data, symbolize_names: true)
            save_event(data)
          end

          ws.on :close do |event|
            puts "Disconnected from WebSocket server"
            EM.stop
          end
        end
      end

      private

      def save_event(data)
        store = Store.find_or_create_by(name: data.dig(:store))

        logger.info("Store: #{store.name}")
      end

      def logger
        @logger ||= Logger.new($stderr)
      end
    end
  end
end
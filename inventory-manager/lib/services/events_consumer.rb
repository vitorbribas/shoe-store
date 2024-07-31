# frozen_string_literal: true

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

          ws.on :open do |_event|
            logger.info("Connected to WebSocket server on #{EVENTS_URL}")
          end

          ws.on :message do |event|
            data = JSON.parse(event.data, symbolize_names: true)
            save_event(data)
          end

          ws.on :close do |_event|
            logger.info('Disconnected from WebSocket server')
            EM.stop
          end
        end
      end

      private

      def save_event(data)
        store = Store.find_or_create_by(name: data[:store])
        model = Model.find_or_create_by(name: data[:model])

        inventory = store.inventories.create(model:, amount: data[:inventory])

        logger.info("Store: #{inventory.attributes}")
      end

      def logger
        @logger ||= Logger.new($stderr)
      end
    end
  end
end

require_relative '../services/events_consumer'

namespace :consume_events do
  task start: :environment do
    Services::EventsConsumer.start
  end
end

require "socket"

require_relative "flo/version"
require_relative "flo/protocol/byte_reader"
require_relative "flo/protocol/byte_writer"
require_relative "flo/protocol/message_serializer"
require_relative "flo/event_id"
require_relative "flo/config"
require_relative "flo/client"

module Flo

  def self.config
    @config ||= Config.defaults
    yield @config if block_given?
    @config
  end

  def self.client
    client = Client.new
    client.connect
    yield client
  ensure
    client.disconnect
  end

end

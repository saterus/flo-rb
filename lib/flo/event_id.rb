module Flo
  class EventId

    def self.parse(decimal_delimited)
      return zero if decimal_delimited.nil? || decimal_delimited.empty?

      counter, actor = decimal_delimited.split(".").map(&:to_i)
      new(counter, actor)
    end

    def self.zero
      new(0, 0)
    end

    attr_reader :counter, :actor

    def initialize(counter, actor)
      @counter = counter
      @actor = actor
    end

  end
end

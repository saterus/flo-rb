module Flo
  class MessageSerializer
    PRODUCE_HEADER = "FLO_PRO\n"

    def initialize(namespace, op_id, parent_event, data)
      @namespace = namespace
      @op_id = op_id
      @parent_event = parent_event
      @data = data
    end

    def serialize
      stream = ByteStreamWriter.new

      stream.str(PRODUCE_HEADER)
      stream.puts(@namespace)
      stream.u64(@parent_event.counter)
      stream.u16(@parent_event.actor)
      stream.u32(@op_id)
      stream.u32(@data.length)

      stream.str(@data)

      stream
    end

  end
end

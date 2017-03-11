module Flo
  class Client

    def initialize(host, port)
      @host = host
      @port = port
      @socket = nil
    end

    def connect
      @socket = TCPSocket.new(@host, @port)
      self
    end

    PRODUCE_HEADER = "FLO_PRO"
    def produce(namespace, message_data, op_id: 0, counter: 0, actor: 0)
      stream = ByteStreamWriter.new

      stream.puts(PRODUCE_HEADER)
      stream.puts(namespace)
      stream.u64(counter)
      stream.u16(actor)
      stream.u32(op_id)
      stream.u32(message_data.length)

      stream.str(message_data)

      @socket.write(stream)
    end

  end
end

module Flo
  class Client

    def initialize(host: Flo.config.host, port: Flo.config.port)
      @host = host
      @port = port
      @socket = nil
    end

    def connect
      @socket = TCPSocket.new(@host, @port)
      self
    end

    PRODUCE_HEADER = "FLO_PRO\n"
    def produce(namespace, message_data, op_id: 0, parent: nil)
      counter, actor = split_parent(parent)

      stream = ByteStreamWriter.new

      stream.str(PRODUCE_HEADER)
      stream.puts(namespace)
      stream.u64(counter)
      stream.u16(actor)
      stream.u32(op_id)
      stream.u32(message_data.length)

      stream.str(message_data)

      @socket.write(stream)
      parse_ack
    end

    ACK_HEADER = "FLO_ACK\n"
    ERROR_HEADER = "FLO_ERR\n"
    def parse_ack
      ack, _ = @socket.recvfrom(64)

      reader = ByteStreamReader.new(ack)
      header = reader.chars(8)
      case header
      when ACK_HEADER then read_ack(reader)
      when ERROR_HEADER then read_error(reader)
      else
      puts reader
        raise "Cannot read the ack header: #{header}"
      end
    end

    def read_ack(reader)
      op_id = reader.u32
      counter = reader.u64
      actor = reader.u16
      { op_id: op_id, counter: counter, actor: actor }
    end

    def read_error(reader)
      op_id = reader.u32
      err_code = reader.u8
      desc = reader.rest
      raise "Recieved an error: op_id=#{op_id}, err_code=#{err_code}, desc=#{desc}"
    end

    def split_parent(parent_event_id)
      return [0, 0] if parent_event_id.nil? || parent_event_id.empty?

      reader = ByteStreamReader.new(parent_event_id)
      counter = reader.u64
      actor = reader.u16

      [counter, actor]
    end

  end
end

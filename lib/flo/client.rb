module Flo
  class Client
    ACK_HEADER = "FLO_ACK\n"
    ERROR_HEADER = "FLO_ERR\n"

    def initialize(host: Flo.config.host, port: Flo.config.port)
      @host = host
      @port = port
      @socket = nil
    end

    def connect
      @socket = TCPSocket.new(@host, @port)
      self
    end

    def disconnect
      @socket.close
      self
    end

    def produce(namespace, message_data, op_id: 0, parent: EventId.zero)
      message = MessageSerializer.new(namespace, op_id, parent, message_data)

      @socket.write(message.serialize)
      parse_ack(@socket.recvfrom(64).first)
    end

    def parse_ack(ack)
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

  end
end

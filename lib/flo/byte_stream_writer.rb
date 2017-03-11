module Flo
  class ByteStreamWriter
    # Note: everything is big endian bytes, so we force packing with ">".

    def initialize
      @packed = []
    end

    def to_s
      @packed.join('')
    end

    # Q | 64-bit unsigned, native endian (uint64_t)
    def u64(num)
      @packed << [num].pack("Q>")
    end

    # q | 64-bit signed, native endian (int64_t)
    def i64(num)
      @packed << [num].pack("q>")
    end

    # L | 32-bit unsigned, native endian (uint32_t)
    def u32(num)
      @packed << [num].pack("L>")
    end

    # l | 32-bit signed, native endian (int32_t)
    def i32(num)
      @packed << [num].pack("l>")
    end

    # S | 16-bit unsigned, native endian (uint16_t)
    def u16(num)
      @packed << [num].pack("S>")
    end

    # s | 16-bit signed, native endian (int16_t)
    def i16(num)
      @packed << [num].pack("s>")
    end

    # C | 8-bit unsigned (unsigned char)
    def u8(num)
      @packed << [num].pack("C>")
    end

    # c | 8-bit signed (signed char)
    def i8(num)
      @packed << [num].pack("c>")
    end

    def str(s)
      @packed << s
    end

    def puts(s)
      @packed << s
      @packed << "\n"
    end

  end
end


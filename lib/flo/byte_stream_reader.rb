module Flo
  class ByteStreamReader
    # Note: everything is big endian bytes, so we force unpacking with ">".

    def initialize(packed)
      @packed = packed
      @cursor = 0
    end

    def next_bytes(n)
      bytes = @packed.byteslice(@cursor, n)
      @cursor += n
      bytes
    end

    def to_s
      "<ByteStreamReader packed.length=#{@packed.length} cursor=#{@cursor}>"
    end

    # Q | 64-bit unsigned, native endian (uint64_t)
    def u64
      next_bytes(8).unpack("Q>").first
    end

    # q | 64-bit signed, native endian (int64_t)
    def i64
      next_bytes(8).unpack("q>").first
    end

    # L | 32-bit unsigned, native endian (uint32_t)
    def u32
      next_bytes(4).unpack("L>").first
    end

    # l | 32-bit signed, native endian (int32_t)
    def i32
      next_bytes(4).unpack("l>").first
    end

    # S | 16-bit unsigned, native endian (uint16_t)
    def u16
      next_bytes(2).unpack("S>").first
    end

    # s | 16-bit signed, native endian (int16_t)
    def i16
      next_bytes(2).unpack("s>").first
    end

    # C | 8-bit unsigned (unsigned char)
    def u8
      next_bytes(1).unpack("C>").first
    end

    # c | 8-bit signed (signed char)
    def i8
      next_bytes(1).unpack("c>").first
    end

    def chars(n)
      next_bytes(n).unpack("A*").first
    end

    def rest
      chars(@packed.length - @cursor)
    end
  end
end


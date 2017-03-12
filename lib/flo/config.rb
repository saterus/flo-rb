module Flo
  class Config
    attr_accessor :host, :port

    def self.defaults
      config = Config.new
      config.host = "localhost"
      config.port = 3000
      config
    end
  end
end

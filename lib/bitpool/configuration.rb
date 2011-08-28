class Bitpool::Configuration
  attr_accessor :bitcoind_username
  attr_accessor :bitcoind_password
  attr_accessor :bitcoind_host
  attr_accessor :bitcoind_port
  
  def initialize(defaults = {})
    @bitcoind_username = 'user'
    @bitcoind_password = 'pass'
    @bitcoind_host     = 'localhost'
    @bitcoind_port     = 8332
    
    defaults.each do |key, value|
      send("#{key}=", value)
    end
  end
end

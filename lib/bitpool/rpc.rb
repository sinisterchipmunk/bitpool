module Bitpool::RPC
  def self.included(base)
    base.class_eval do
      attr_reader :bitcoin
      after_initialize :setup_bitcoin_client
    end
  end
  
  def setup_bitcoin_client
    @bitcoin = Bitcoin::Client.new(Bitpool.config.bitcoind_username, Bitpool.config.bitcoind_password)
  end
end

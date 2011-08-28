module Bitpool::RPC
  def bitcoin
    @bitcoin ||= Bitcoin::Client.new(Bitpool.config.bitcoind_username, Bitpool.config.bitcoind_password,
                                    :host => Bitpool.config.bitcoind_host, :port => Bitpool.config.bitcoind_port)
  end
end

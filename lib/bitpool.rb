require 'bitcoin-client'
require 'yaml'

module Bitpool
  autoload :Configuration, "bitpool/configuration"
  autoload :Server,        "bitpool/server"
  autoload :Version,       "bitpool/version"
  autoload :VERSION,       "bitpool/version"
  autoload :Models,        "bitpool/models"
  autoload :Target,        "bitpool/target"
  
  autoload :RPC,           "bitpool/rpc"
  autoload :Account,       "bitpool/account"
  autoload :Worker,        "bitpool/worker"
  autoload :Share,         "bitpool/share"
  autoload :Credit,        "bitpool/credit"
  autoload :BlockCredit,   "bitpool/block_credit"
  autoload :SharesCredit,  "bitpool/shares_credit"
  
  class << self
    def config
      @config ||= begin
        fi = File.expand_path(".bitpool", "~")
        yml = YAML::load(File.read(fi)) if File.file?(fi)
        Bitpool::Configuration.new(yml || {})
      end
    end
  end
end

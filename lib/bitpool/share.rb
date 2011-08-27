require 'digest/sha2'

class Bitpool::Share < ActiveRecord::Base
  self.table_name = :bitpool_shares

  include Bitpool::RPC
  include Bitpool::Target

  belongs_to :worker
  after_initialize :check_work
  after_initialize :set_height
  
  validates_presence_of :data
  validates_presence_of :worker
  validates_uniqueness_of :data
  
  validate do |record|
    if record.data && record.check_hash > TARGET
      record.errors.add(:check_hash, "exceeded target")
    end
  end
  
  after_create :examine_block
  
  # credits users if this block was accepted
  def examine_block
    if accepted?
      worker && worker.report_accepted_block(self)
    end
    true
  end
  
  def check_hash
    return nil if !data
    
    if data.kind_of?(String)
      data = self.data.to_i(16)
    end
    
    hash_data = decode_hex(data)[0...80]
    hash_data = bufreverse(hash_data)

    hash1_o = Digest::SHA2.new()
    hash1_o.update(hash_data)
    hash1 = decode_hex(hash1_o.to_s)
    
    hash_o = Digest::SHA2.new()
    hash_o.update(hash1)
    hash = decode_hex(hash_o.to_s)
    
    hash = bufreverse(hash)
    hash = wordreverse(hash)
    
    encode_hex(hash)
  end
  
  def set_height
    self.height ||= bitcoin.getblockcount
  end
  
  def check_work
    if new_record?
      self.accepted = bitcoin.getwork(data)
    end
    true
  end
  
  def accepted?
    accepted
  end
end

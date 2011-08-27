class Bitpool::Worker < ActiveRecord::Base
  self.table_name = :bitpool_workers
  
  include Bitpool::Target
  include Bitpool::RPC
  
  has_many :shares
  has_many :credits
  belongs_to :account

  def request_work(req)
    work = bitcoin.getwork
    work['target'] = TARGET.to_s(16)#targetstr(TARGET)
    # work['target'] = targetstr(TARGET)
    respond_to req['id'], work
  end
  
  def complete_work(req)
    data = req['params'][0]
    share = shares.create!(:data => data)
    respond_to req['id'], share.accepted
  end
  
  def report_accepted_block(block)
    up_to_this_block = ['height <= ?', block.height]
    
    Bitpool::Worker.transaction do
      Bitpool::Worker.all.each do |worker|
        count = worker.shares.count(:conditions => up_to_this_block)
        worker.credits << Bitpool::SharesCredit.create!(:count => count, :height => block.height)
        if block.worker == worker
          worker.credits << Bitpool::BlockCredit.create!(:height => block.height)
        end
      end
      Bitpool::Share.destroy_all(up_to_this_block)
    end
  end
  
  def respond_to(request_id, result, error = nil)
    {
      'version' => '1.1',
      'id' => request_id,
      'error' => error,
      'result' => result
    }
  end
end

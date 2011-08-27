class Bitpool::Worker < Redis::ORM
  include Bitpool::Target
  include Bitpool::RPC
  
  attribute :name
  has_many :shares, :relation => :worker
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
    share = Bitpool::Share.new(:data => data, :account => account, :worker => self)
    if share.save
      shares << share
      save
    end
    respond_to req['id'], share.accepted
  end
  
  def report_accepted_block(block)
    all_workers = []
    Bitpool::Share.all.each do |share|
      if share.height <= block.height
        credit = Bitpool::Credit.create
        worker = share.worker
        worker.credits << credit
        all_workers << worker unless all_workers.include?(worker)
        share.destroy
      end
    end
    all_workers.each { |worker| worker.save! }
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

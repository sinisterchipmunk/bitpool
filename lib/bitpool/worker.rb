class Bitpool::Worker < Redis::ORM
  include Bitpool::Target
  include Bitpool::RPC
  
  attribute :name
  has_many :shares
  belongs_to :account

  def request_work(req)
    work = bitcoin.getwork
    work['target'] = TARGET.to_s(16)#targetstr(TARGET)
    # work['target'] = targetstr(TARGET)
    respond_to req['id'], work
  end
  
  def complete_work(req)
    data = req['params'][0]
    share = Bitpool::Share.new(:data => data, :account => account)
    if share.save
      shares << share
      save
    end
    respond_to req['id'], share.accepted
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

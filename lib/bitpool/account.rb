class Bitpool::Account < Redis::ORM
  has_many :workers
  attr_accessor :active_worker
  
  class << self
    def authenticate(account_key, worker_name)
      account = find(account_key) || new(:id => account_key)
      unless worker = account.workers.select { |w| w.name == worker_name }.first
        worker = Bitpool::Worker.create(:name => worker_name)
        account.workers << worker
      end
      account.active_worker = worker
      account.save
      account
    end
  end
end

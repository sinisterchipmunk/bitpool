class Bitpool::Account < ActiveRecord::Base
  self.table_name = :bitpool_accounts
  has_many :workers
  attr_accessor :active_worker
  delegate :request_work, :complete_work, :to => :active_worker
  
  class << self
    def authenticate(account_key, worker_name)
      account = find_by_key(account_key) || create(:key => account_key)
      unless worker = account.workers.find_by_name(worker_name)
        worker = account.workers.create(:name => worker_name)
      end
      account.active_worker = worker
      account
    end
  end
end

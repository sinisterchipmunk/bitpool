class Bitpool::Credit < ActiveRecord::Base
  self.table_name = :bitpool_credits
  belongs_to :worker
end

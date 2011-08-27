class Bitpool::BlockCredit < Bitpool::Credit
  after_initialize do |credit|
    credit.count = 1
  end
end

require 'spec_helper'

describe Bitpool::Models::Redis::Account do
  include RedisHelper
  
  describe "authenticating" do
    it "should assign worker and account attributes" do
      user = Bitpool::Models::Redis::Account.authenticate('one', 'two')
      user.key.should_not be_nil
      user.worker.name.should_not be_nil
      user.worker.key.should_not be_nil
    end

    it "should insert a new user" do
      account = Bitpool::Models::Redis::Account.authenticate('one', 'two')
      redis.scard(account.key).should == 1
    end
  end
end

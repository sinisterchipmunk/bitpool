require 'spec_helper'

describe Bitpool::Models::Redis::Worker do
  include RedisHelper
  
  subject { Bitpool::Models::Redis::Worker.new(:account => 'one', :name => 'two') }
  
  describe "with a share" do
    before :each do
      subject.shares << Bitpool::Models::Redis::Share.new(:hash => 100)
      subject.shares.length.should == 1 # sanity check
    end
    
    it "should persist shares" do
      worker = Bitpool::Models::Redis::Worker.new(:account => subject.account, :name => subject.name)
      worker.shares.length.should == 1
      worker.shares[0].should be_kind_of(Bitpool::Models::Redis::Share)
      # range
      worker.shares[0..0][0].should be_kind_of(Bitpool::Models::Redis::Share)
    end
  end
  
  it "should raise an error when explicitly adding an invalid share" do
    proc { subject.shares << Bitpool::Models::Redis::Share.new }.should raise_error
  end
  
  describe "completing an invalid share" do
    before :each do
      share = Bitpool::Models::Redis::Share.new
      share.stub(:valid?).and_return(false)
      
      subject.complete_share share
    end
    
    it "should not be added to shares" do
      subject.shares.should be_empty
    end
  end
    
  describe "completing a valid share" do
    before :each do
      share = Bitpool::Models::Redis::Share.new(:hash => 100)
      subject.complete_share share
    end
    
    it "should add the share to its shares list" do
      subject.shares.length.should == 1
    end
    
    it "should set the share's key" do
      subject.shares[0].worker_key.should == subject.key
    end
  end
end

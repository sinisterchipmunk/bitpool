require 'spec_helper'

describe Bitpool::Models::Redis::Share do
  include RedisHelper
  
  before(:each) { @valid_attributes = { :hash => 100 } }
  
  context "with valid attributes" do
    before(:each) { subject.attributes = @valid_attributes }
    
    it "should save" do
      redis.hgetall(Bitpool::Models::Redis::Share.model_name).should be_empty # sanity check
      subject.save!
      redis.hgetall(Bitpool::Models::Redis::Share.model_name).should_not be_empty
    end
  end
  
  it "should not be valid without hash" do
    @valid_attributes.delete :hash
    subject.attributes = @valid_attributes
    subject.should_not be_valid
  end
  
  it "should not save an invalid hash" do
    redis.get(subject.key).should be_nil
    subject.save.should be_false
    redis.get(subject.key).should be_nil
  end
  
  it "should not allow duplicates" do
    subject.hash = 100
    subject.save.should be_true # sanity check
    subject.save.should be_false
  end
  
  describe "exceeding target" do
    before :each do
      subject.hash = Bitpool::Models::Redis::Share::TARGET + 1
    end
    
    it "should be invalid" do
      subject.should_not be_valid
    end
  end
end

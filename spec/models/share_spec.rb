require 'spec_helper'

describe Bitpool::Share do
  subject { Bitpool::Share.new(valid_attributes) }
  
  before(:each) { FakeWeb.register_uri(:post, 'http://user:pass@localhost:8332/', :response => fixture('getwork_valid_with_param')) }
  
  def valid_attributes
    { :data => "01000000" +
        "81cd02ab7e569e8bcd9317e2fe99f2de44d49ab2b8851ba4a308000000000000" +
        "e320b6c2fffc8d750423db8b1eb942ae710e951ed797f7affc8892b0f1fc122b" +
        "c7f5d74d" +
        "f2b9441a" +
         "42a14695" }
  end
  
  it "should calculate check hash properly" do
    subject = Bitpool::Share.new(:data => valid_attributes[:data])
    subject.check_hash.should == 0x000f67d1f74b5700b39d49067a41e597be13460fb79f9d1d40f7f2103b9fac21
  end
  
  context "with checkwork hash exceeding TARGET" do
    before(:each) { subject.should_receive(:check_hash).and_return(Bitpool::Target::TARGET + 1) }
    
    it "should not be valid" do
      subject.should_not be_valid
    end
  end
  
  context "with an accepted block" do
    it "should report the block" do
      worker = Bitpool::Worker.create!(:name => "worker")
      worker.should_receive(:report_accepted_block)
      share = Bitpool::Share.new(:data => valid_attributes[:data], :worker => worker)
      share.save!
    end
  end
  
  it "should not be valid with duplicate data" do
    # p Bitpool::Share.new(valid_attributes).data
    Bitpool::Share.new(valid_attributes).save!
    Bitpool::Share.new(valid_attributes).should_not be_valid
  end
end

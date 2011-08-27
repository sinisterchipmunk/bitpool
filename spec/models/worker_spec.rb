require 'spec_helper'

describe Bitpool::Worker do
  subject { Bitpool::Account.authenticate('1234', 'worker').active_worker }
  
  context "receiving an accepted block" do
    before(:each) do
      values = [ 142402, 142403, 142404, 142407,   142406 ]
      Bitcoin::Client.any_instance.stub(:getblockcount).and_return() { values.shift }
      Bitcoin::Client.any_instance.stub(:getwork).and_return(false)
      
      4.times do |i|
        Bitpool::Share.create!(:data => '1234'+i.to_s, :worker => subject)
      end
      
      subject.bitcoin.stub(:getwork).and_return(true)
      subject.report_accepted_block(Bitpool::Share.create!(:data => '123410', :worker => subject))
    end
    
    it "should create credits for each share with height less than accepted share height" do
      subject.credits.should have(4).items
    end
  end
  
  context "completing work" do
    before(:each) do
      @req = { 'params' => [ 'a791feeb00ae7fce4c7147b7bcbb525616a93552e7e96c45b48cc56aed3311c1' ], 'method' => 'getwork' }
      subject.bitcoin.stub(:getblockcount).and_return(142407)
    end
    
    context "with valid checkwork" do
      before(:each) do
        subject.stub(:check_work).and_return(100)
        FakeWeb.register_uri(:post, 'http://user:pass@localhost:8332/', :response => fixture('getwork_valid_with_param'))
      end
      
      it "should add a share" do
        subject.complete_work(@req)
        subject.shares.should_not be_empty
      end
    end
  end
  
  context "requesting work" do
    before(:each) { @req = { 'params' => [], 'method' => 'getwork' } }
    
    it "should return work to be performed" do
      FakeWeb.register_uri(:post, 'http://user:pass@localhost:8332/', :response => fixture('getwork_without_params'))
      
      subject.request_work(@req).should == {
        'version' => '1.1',
        'id' => @req['id'],
        'error' => nil,
        'result' => {
          "midstate" => "a791feeb00ae7fce4c7147b7bcbb525616a93552e7e96c45b48cc56aed3311c1",
          "data" => "00000001bfe727496d32d669ce18f6cb7b10648f7c037b60d7c55cb0000002100000000023eef4d11321e6a8080b1b5b73ded032bc2a415730ad4b48f4d1973e2332734b4e550fcc1a094a8600000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000080020000",
          "hash1" => "00000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000010000",
          "target" => "ffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000"
        }
      }
    end
  end
end

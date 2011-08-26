require 'spec_helper'

describe Bitpool::Account do
  describe "authenticating with account key and worker name" do
    subject { Bitpool::Account.authenticate('1234', 'worker') }
    
    it "should not be a new record" do
      subject.should_not be_new_record
    end
    
    it "should not be changed" do
      subject.should_not be_changed
    end
    
    it "should have the named worker" do
      subject.workers.first.name.should == 'worker'
    end
    
    it "should have the specified account key" do
      subject.id.should == '1234'
    end
    
    it "should find existing account" do
      first = Bitpool::Account.create!(:id => '1234')
      subject.should == first
    end
    
    it "should find existing workers" do
      account = Bitpool::Account.new(:id => '1234')
      account.workers << Bitpool::Worker.create!(:name => 'worker')
      account.save!
      
      subject.should == account
      subject.workers.first.should == account.workers.first
    end
    
    it "should create new workers even if the same name already exists" do
      worker = Bitpool::Worker.create!(:name => 'worker')
      subject.workers.first.should_not == worker
    end
    
    it "should assign the active worker" do
      subject.active_worker.should be_kind_of(Bitpool::Worker)
    end
  end
end

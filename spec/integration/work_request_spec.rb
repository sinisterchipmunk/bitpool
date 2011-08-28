require 'spec_helper'

describe "request a new batch of work" do
  include RackHelper

  it "should return the work" do
    post :getwork
    response_json['result']['data'].should_not be_blank
  end
end

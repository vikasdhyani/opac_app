require 'spec_helper'

describe "Factories" do
  [:delivery_order, :ibtr, :user, :dev_membership, :delivery_slot, :delivery_schedule, :dev_title].each do |type|
    it "can create a valid object of #{type}" do
      Factory.build(type).should be_valid
    end
  end
end
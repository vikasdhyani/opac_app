describe Ibtr do
  context "Availability" do
    it "is in the warehouse when it is dispatched" do
      Factory(:ibtr, :state => "Dispatched").should be_in_warehouse
    end

    it "is not in the warehouse when it is not fulfilled" do
      Factory(:ibtr, :state =>"New").should_not be_in_warehouse
    end
  end
end
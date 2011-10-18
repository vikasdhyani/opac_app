require "rspec"

describe ApplicationHelper do
  context "delivery date format" do
    it "should format delivery date" do
      slot = Factory(:delivery_slot)
      helper.should_receive(:delivery_schedule_path).with(:delivery_date => "2010/02/01", :slot_id => slot.id)
      helper.schedule_by_date_and_slot_path(Date.new(2010, 02, 01), slot)
    end

    it "should format the allotment path" do
      helper.should_receive(:delivery_schedule_allotment_path).with(:delivery_date => "2010/02/01")
      helper.schedule_allotment_path(Date.new(2010, 02, 01))
    end
  end
end

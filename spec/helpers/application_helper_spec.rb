require "rspec"

describe ApplicationHelper do
  context "delivery date format" do
    it "should format delivery date" do
      slot = Factory(:delivery_slot)
      helper.should_receive(:show_delivery_schedule_path).with(:delivery_date => "2010/02/01", :slot_id => slot.id)
      helper.schedule_by_date_and_slot_path(Date.new(2010, 02, 01), slot)
    end
  end
end

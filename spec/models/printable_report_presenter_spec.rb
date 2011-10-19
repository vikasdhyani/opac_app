require 'spec_helper'

describe PrintableReportPresenter do
  let(:tomorrow) { Date.tomorrow }
  let(:presenter) { PrintableReportPresenter.new(tomorrow.strftime("%Y/%m/%d")) }

  it "should contain the list of all slots" do
    slot = Factory(:delivery_slot)
    presenter.slots.should == [slot]
  end

  it "should contain the list of all delivery persons" do
    delivery_person = Factory(:delivery_person)
    presenter.delivery_people.should == [delivery_person]
  end

  context "getting the order list" do
    let(:slot) { Factory(:delivery_slot) }
    let(:person) { Factory(:delivery_person) }
    let(:schedule) { Factory(:delivery_schedule, :delivery_date => tomorrow, :delivery_slot => slot) }

    it "gets the order lists for a particular delivery person" do
      Factory(:delivery_order, :membership_no => "M1", :delivery_schedule => schedule)
      Factory(:delivery_person_allotment, :delivery_schedule => schedule, :delivery_person => person, :membership_no => "M1")
      order_lists = presenter.order_lists_for(person, slot)
      order_lists.should have(1).things
      order_lists[0].membership_no.should == "M1"
    end

    it "does not return deliveries that are not allotted" do
      Factory(:delivery_order, :membership_no => "M1", :delivery_schedule => schedule)
      order_lists = presenter.order_lists_for(person, slot)
      order_lists.should be_empty
    end
  end
end

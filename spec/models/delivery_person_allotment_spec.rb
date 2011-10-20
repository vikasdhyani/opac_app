require 'spec_helper'

describe DeliveryPersonAllotment do
  context "validations" do
    subject { Factory(:delivery_person_allotment) }
    it { should belong_to(:delivery_person) }
    it { should belong_to(:delivery_schedule) }
    it { should validate_uniqueness_of(:membership_no).scoped_to(:delivery_schedule_id) }
    it { should validate_presence_of(:membership_no) }
    it { should validate_presence_of(:delivery_schedule_id) }
  end
end

require 'spec_helper'

describe DeliverySchedule do
  context "validations" do
  subject { Factory(:delivery_schedule) }
  it { should belong_to(:delivery_slot) }
  it { should validate_presence_of(:delivery_slot_id) }
  it { should validate_presence_of(:delivery_date) }
  it { should validate_uniqueness_of(:delivery_date).scoped_to(:delivery_slot_id)}
  end
end

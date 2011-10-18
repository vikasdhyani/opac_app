class DeliveryPersonAllotment < ActiveRecord::Base
  belongs_to :delivery_person
  belongs_to :delivery_schedule
  validates_uniqueness_of :membership_no, :scope => :delivery_schedule_id
end

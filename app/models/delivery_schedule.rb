class DeliverySchedule < ActiveRecord::Base
  belongs_to :delivery_slot
end

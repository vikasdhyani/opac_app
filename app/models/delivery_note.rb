class DeliveryNote < ActiveRecord::Base
  validates_presence_of :content

  belongs_to :delivery_order
end

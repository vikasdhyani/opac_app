FactoryGirl.define do
  factory :delivery_schedule do
    delivery_slot { Factory(:delivery_slot) }
    delivery_date Date.tomorrow
  end
end
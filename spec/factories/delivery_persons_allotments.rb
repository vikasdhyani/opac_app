FactoryGirl.define do
  factory :delivery_person_allotment do
    delivery_schedule { Factory(:delivery_schedule) }
    delivery_person { Factory(:delivery_person) }
    membership_no "Foobar"
  end
end

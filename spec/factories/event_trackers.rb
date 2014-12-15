FactoryGirl.define do
  factory :event_tracker do
    name             'first event tracker'
    is_deleted       false
    user_id          1
    organization_id  1
    contact_user_ids [1]
  end
end

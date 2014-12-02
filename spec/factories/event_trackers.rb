FactoryGirl.define do
  factory :event_tracker do
    name            'first event tracker'
    email           'email@sample.com'
    is_deleted      false
    user_id         1
    organization_id 1
  end
end

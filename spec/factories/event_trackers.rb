FactoryGirl.define do
  factory :event_tracker do
    name         'first event tracker'
    email        'email@sample.com'
    interval_cd  EventTracker.interval(:hourly).id
    association  :user
    association  :organization, name: "Widget Co."
  end
end

FactoryGirl.define do
  factory :user do
    id           1
    name         'first last'
    email        'email@sample.com'
    password     'password'
    association  :organization, name: "Widget Co."
  end
end

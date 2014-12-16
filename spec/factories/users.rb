FactoryGirl.define do
  factory :user do
    id           1
    name         'first last'
    email        'email@sample.com'
    password     'password'
    association  :organization, name: "Widget Co."
  end

  factory :contact_user, class: :user do
    id           2
    name         'first last2'
    email        'contact@sample.com'
    password     'password'
    role_cd      User.role(:contact).id
  end
end

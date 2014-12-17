FactoryGirl.define do
  factory :todo_category do
    id              1
    name            'category'
    short_name      'cat'
    user_id         1
    organization_id 1
  end
end

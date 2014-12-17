FactoryGirl.define do
  factory :todo do
    id                  1
    title               'title'
    user_id             1
    todo_category_id    1
    created_by_user_id  1
  end
end

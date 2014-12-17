FactoryGirl.define do
  factory :task do
    id                  1
    title               'title'
    user_id             1
    task_category_id    1
    created_by_user_id  1
  end
end

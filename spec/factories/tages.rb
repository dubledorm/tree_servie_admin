FactoryGirl.define do
  factory :tag, class: Tag do
    sequence(:name) { |n| "name#{n}" }
    value_type 'int'
    value_int 10
    node
  end
end

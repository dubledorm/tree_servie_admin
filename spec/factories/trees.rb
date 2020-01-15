FactoryGirl.define do
  factory :tree, class: Tree do
    sequence(:name) { |n| "name#{n}" }
    description 'Описание дерева'
    instance
  end
end

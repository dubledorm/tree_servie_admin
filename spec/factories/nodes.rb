FactoryGirl.define do
  factory :node, class: Node do
    sequence(:name) { |n| "name#{n}" }
    description 'Описание node'
    state 'active'
    tree
  end
end

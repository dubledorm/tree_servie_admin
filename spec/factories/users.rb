FactoryGirl.define do
  factory :user, class: User do
    sequence(:name) { |n| "name#{n}" }
    ability 'wefasdfs'
    tree
  end
end

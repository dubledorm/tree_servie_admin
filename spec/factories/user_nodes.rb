FactoryGirl.define do
  factory :user_node, class: UserNode do
    user { FactoryGirl.create(:user) }
    node { FactoryGirl.create( :node, tree_id: user.tree.id)}
  end
end

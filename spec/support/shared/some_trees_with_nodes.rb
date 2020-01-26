RSpec.shared_context 'some trees with nodes' do
  let!(:instance1) { FactoryGirl.create(:instance) }
  let!(:instance2) { FactoryGirl.create(:instance) }
  let!(:tree1) { FactoryGirl.create(:tree, instance: instance1, name: 'objects') }
  let!(:tree2) { FactoryGirl.create(:tree,  instance: instance1, name: 'topology1') }
  let!(:tree3) { FactoryGirl.create(:tree, instance: instance2, name: 'objects') }
  let!(:node1) { FactoryGirl.create(:node, tree: tree1) }
  let!(:node2) { FactoryGirl.create(:node, tree: tree2) }
  let!(:node3) { FactoryGirl.create(:node, tree: tree3) }

  let!(:user1) { FactoryGirl.create(:user, tree: tree1) }
  let!(:user2) { FactoryGirl.create(:user, tree: tree2) }
  let!(:user3) { FactoryGirl.create(:user, tree: tree3) }
  let!(:user12) { FactoryGirl.create(:user, tree: tree1) }
end

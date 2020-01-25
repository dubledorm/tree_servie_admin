RSpec.shared_context 'many nodes with parents' do
  let!(:instance1) { FactoryGirl.create(:instance) }
  let!(:instance2) { FactoryGirl.create(:instance) }

  let!(:tree1) { FactoryGirl.create(:tree, instance: instance1) }
  let!(:tree2) { FactoryGirl.create(:tree,  instance: instance1) }
  let!(:tree3) { FactoryGirl.create(:tree, instance: instance2) }

  let!(:node1) { FactoryGirl.create(:node, tree: tree1) }
  let!(:node2) { FactoryGirl.create(:node, tree: tree2) }
  let!(:node3) { FactoryGirl.create(:node, tree: tree3) }

  let!(:node11) { FactoryGirl.create(:node, tree: tree1, parent_id: node1.id) }
  let!(:node12) { FactoryGirl.create(:node, tree: tree1, parent_id: node1.id) }
  let!(:node13) { FactoryGirl.create(:node, tree: tree1, parent_id: node1.id) }

  let!(:node121) { FactoryGirl.create(:node, tree: tree1, parent_id: node12.id) }
end

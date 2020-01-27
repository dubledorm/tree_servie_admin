RSpec.shared_context 'full data example' do
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

  let!(:tag121_1) { FactoryGirl.create(:tag, node: node121) }
  let!(:tag121_2) { FactoryGirl.create(:tag, node: node121) }

  let!(:tag11_1) { FactoryGirl.create(:tag, node: node11) }
  let!(:tag11_2) { FactoryGirl.create(:tag, node: node11) }

  let!(:tag3_1) { FactoryGirl.create(:tag, node: node3) }

  let!(:user_admin) { FactoryGirl.create(:user, name: 'admin', tree: tree1) }
  let!(:user_mc_1) { FactoryGirl.create(:user, name: 'mc_read', ability: 'read', tree: tree1) }
  let!(:user_mc_2) { FactoryGirl.create(:user, name: 'mc_tag', ability: 'write_tag', tree: tree1) }

  let!(:mc1_node11) { FactoryGirl.create(:user_node, user: user_mc_1, node: node11) }
  let!(:mc1_node12) { FactoryGirl.create(:user_node, user: user_mc_1, node: node12) }
  let!(:mc2_node11) { FactoryGirl.create(:user_node, user: user_mc_2, node: node11) }
  let!(:mc2_node121) { FactoryGirl.create(:user_node, user: user_mc_2, node: node121) }
end

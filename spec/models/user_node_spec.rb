require 'rails_helper'

RSpec.describe UserNode, type: :model do
  let!(:user_node) {FactoryGirl.create :user_node}

  # Factories
  it { expect(user_node).to be_valid }

  # Validations
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:node) }

  # Relationships
  it {should belong_to(:user)}
  it {should belong_to(:node)}

  describe 'validations' do
    context 'when tree of user not eq tree of node' do
      let!(:tree1) { FactoryGirl.create(:tree) }
      let!(:tree2) { FactoryGirl.create(:tree) }
      let!(:user1) { FactoryGirl.create(:user, tree: tree1) }
      let!(:node1) { FactoryGirl.create(:node, tree: tree1) }
      let!(:node2) { FactoryGirl.create(:node, tree: tree2) }

      it { expect(FactoryGirl.build(:user_node, user: user1, node: node2)).to be_invalid}
      it { expect(FactoryGirl.build(:user_node, user: user1, node: node1)).to be_valid}
    end
  end
end

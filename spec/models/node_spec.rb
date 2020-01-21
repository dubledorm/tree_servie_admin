require 'rails_helper'

RSpec.describe Node, type: :model do
  describe 'factory' do
    let!(:node) { FactoryGirl.create :node }

    # Factories
    it { expect(node).to be_valid }

    # Validations
    it { should validate_presence_of(:tree) }

    # Relationships
    it {should belong_to(:tree)}
    it {should belong_to(:parent)}
    it {should have_one(:instance)}
    it {should have_many(:tags)}
    it {should have_many(:user_nodes)}
    it {should have_many(:users)}
  end

  describe 'validations' do
    let!(:tree1) { FactoryGirl.create :tree }
    let!(:tree2) { FactoryGirl.create :tree }
    let!(:node11) { FactoryGirl.create :node, tree: tree1 }
    let!(:node12) { FactoryGirl.create :node, tree: tree2 }


    context 'when parent_id node is wrong' do
      let(:node1) { FactoryGirl.build(:node, tree: tree1, parent: node11) }
      let(:node2) { FactoryGirl.build(:node, tree: tree1, parent: node12) }

      it { expect(node1).to be_valid }
      it { expect(node2).to be_invalid }
    end
  end
end

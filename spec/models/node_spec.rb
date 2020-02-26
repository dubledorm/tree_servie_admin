require 'rails_helper'
require 'support/shared/many_nodes_with_parents'

RSpec.describe Node, type: :model do
  describe 'factory' do
    let!(:node) { FactoryGirl.create :node }

    # Factories
    it { expect(node).to be_valid }

    # Validations
    it { should validate_presence_of(:tree) }
    it { should validate_presence_of(:state) }

    # Relationships
    it { should belong_to(:tree) }
    it { should belong_to(:parent) }
    it { should have_one(:instance) }
    it { should have_many(:tags) }
    it { should have_many(:user_nodes) }
    it { should have_many(:users) }
    it { should have_many(:children) }
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

    context 'when state is right' do
      it { expect(FactoryGirl.build(:node, state: 'active')).to be_valid}
      it { expect(FactoryGirl.build(:node, state: 'deleted')).to be_valid}
    end

    context 'when state is wrong' do
      it { expect(FactoryGirl.build(:node, state: 'abrakadabra')).to be_invalid}
    end
  end

  describe 'children' do
    include_context 'many nodes with parents'

    it { expect(node1.children.count).to eq(3) }
    it { expect(node12.children.count).to eq(1) }
    it { expect(node3.children.count).to eq(0) }
  end

  describe 'roots' do
    let!(:tree1) { FactoryGirl.create :tree }
    let!(:tree2) { FactoryGirl.create :tree }
    let!(:node11) { FactoryGirl.create :node, tree: tree1 }
    let!(:node12) { FactoryGirl.create :node, tree: tree2 }

    let(:node1) { FactoryGirl.build(:node, tree: tree1, parent: node11) }
    let(:node2) { FactoryGirl.build(:node, tree: tree1, parent: node12) }

    it { expect(Node.roots.count).to eq(2) }
  end

  describe 'scopes' do
    let!(:node11) { FactoryGirl.create :node, name: 'the node 11' }
    let!(:node12) { FactoryGirl.create :node, name: 'the node 12' }
    let!(:node13) { FactoryGirl.create :node, name: 'это тринадцатый нод' }
    let!(:node14) { FactoryGirl.create :node, name: 'это четырнадцатый нод' }
    let!(:node15) { FactoryGirl.create :node, name: 'нод' }

    context 'when by_name scope presents' do
      it { expect(Node.by_name('the node 12').count).to eq(1) }
      it { expect(Node.by_name('the node 12').first).to eq(node12) }

      it { expect(Node.by_name('это четырнадцатый нод').count).to eq(1) }
      it { expect(Node.by_name('это четырнадцатый нод').first).to eq(node14) }
    end

    context 'when like_name scope presents' do
      it { expect(Node.like_name('the node 12').count).to eq(1) }
      it { expect(Node.like_name('the node 12').first).to eq(node12) }

      it { expect(Node.like_name('12').count).to eq(1) }
      it { expect(Node.like_name('12').first).to eq(node12) }


      it { expect(Node.like_name('это четырнадцатый нод').count).to eq(1) }
      it { expect(Node.like_name('это четырнадцатый нод').first).to eq(node14) }

      it { expect(Node.like_name('нод').count).to eq(3) }
      it { expect(Node.like_name('четырнадцатый').first).to eq(node14) }
    end
  end

  describe 'scopes by tags' do
    let!(:node11) { FactoryGirl.create :node, name: 'the node 11' }
    let!(:node12) { FactoryGirl.create :node, name: 'the node 12' }
    let!(:node13) { FactoryGirl.create :node, name: 'это тринадцатый нод' }
    let!(:node14) { FactoryGirl.create :node, name: 'это четырнадцатый нод' }


    let!(:tag1) { FactoryGirl.create(:tag, node: node11,
                                     name: 'name1', value_type: 'string',
                                     value_string: 'string1') }
    let!(:tag2) { FactoryGirl.create(:tag, node: node12,
                                     name: 'name1', value_type: 'string',
                                     value_string: 'string1') }
    let!(:tag3) { FactoryGirl.create(:tag, node: node13,
                                     name: 'name1', value_type: 'string',
                                     value_string: 'string2') }
    let!(:tag4) { FactoryGirl.create(:tag, node: node14,
                                     name: 'name1', value_type: 'int',
                                     value_string: 'string1', value_int: 4) }

    it { expect(Node.has_string_tag('name1', 'string1').count).to eq(2) }
    it { expect(Node.has_string_tag('name1', 'string2').count).to eq(1) }
    it { expect(Node.has_string_tag('name2', 'string1').count).to eq(0) }
    it { expect(Node.has_string_tag('name1', 'string222222').count).to eq(0) }
    it { expect(Node.has_int_tag('name1', 4).count).to eq(1) }

    it { expect(Node.has_tag('name1').count).to eq(4) }

  end
end

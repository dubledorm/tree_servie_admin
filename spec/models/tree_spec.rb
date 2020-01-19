require 'rails_helper'

describe Tree do
  describe 'factory' do
    let!(:tree) {FactoryGirl.create :tree}

    # Factories
    it { expect(tree).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:instance) }

    # Relationships
    it {should belong_to(:instance)}
    it {should have_many(:nodes)}
    it {should have_many(:users)}
  end

  context 'when double name' do
    let!(:instance1)  {FactoryGirl.create :instance}
    let!(:instance2)  {FactoryGirl.create :instance}
    let!(:tree1) {FactoryGirl.create :tree, name: 'tree1', instance: instance1}
    let!(:tree2) {FactoryGirl.create :tree, name: 'tree2', instance: instance2}
    let!(:tree11) {FactoryGirl.build :tree, name: 'tree1', instance: instance1}
    let!(:tree12) {FactoryGirl.build :tree, name: 'tree1', instance: instance2}
    let!(:tree11_1) {FactoryGirl.build :tree, name: 'tree1_1', instance: instance1}


    it { expect(tree11).to be_invalid }
    it { expect(tree12).to be_valid }
    it { expect(tree11_1).to be_valid }
  end
end

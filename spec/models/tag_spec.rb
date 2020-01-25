require 'rails_helper'

RSpec.describe Tag, type: :model do

  describe 'factory' do
    let!(:tag) {FactoryGirl.create :tag}

    # Factories
    it { expect(tag).to be_valid }

    # Validations
    it { should validate_presence_of(:value_type) }

    # Relationships
    it {should belong_to(:node)}
    it {should have_one(:tree)}
    it {should have_one(:instance)}
  end

  describe 'validations' do
    let!(:node1) { FactoryGirl.create :node }
    let!(:node2) { FactoryGirl.create :node }


    describe 'tag name uniqness' do
      let!(:tag1) { FactoryGirl.create(:tag, node: node1, name: 'name1') }
      let(:tag2) { FactoryGirl.build(:tag, node: node1, name: 'name1') }
      let(:tag3) { FactoryGirl.build(:tag, node: node1, name: 'name13') }
      let(:tag4) { FactoryGirl.build(:tag, node: node2, name: 'name1') }



      it { expect(tag2).to be_invalid }
      it { expect(tag3).to be_valid }
      it { expect(tag4).to be_valid }
    end
  end
end

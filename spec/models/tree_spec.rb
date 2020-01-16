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
end

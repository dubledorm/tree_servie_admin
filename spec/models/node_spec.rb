require 'rails_helper'

RSpec.describe Node, type: :model do
  let!(:node) {FactoryGirl.create :node}

  # Factories
  it { expect(node).to be_valid }

  # Validations
  it { should validate_presence_of(:tree) }

  # Relationships
  it {should belong_to(:tree)}
  it {should belong_to(:parent)}
  it {should have_one(:instance)}
  it {should have_many(:tags)}
end

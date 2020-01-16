require 'rails_helper'

RSpec.describe Tag, type: :model do
  let!(:tag) {FactoryGirl.create :tag}

  # Factories
  it { expect(tag).to be_valid }

  # Validations
  it { should validate_presence_of(:value_type) }

  # Relationships
  it {should belong_to(:node)}
end

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) {FactoryGirl.create :user}

  # Factories
  it { expect(user).to be_valid }

  # Validations
  it { should validate_presence_of(:ability) }
  it { should validate_presence_of(:tree) }

  # Relationships
  it {should belong_to(:tree)}
end

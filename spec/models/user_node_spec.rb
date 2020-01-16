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
end

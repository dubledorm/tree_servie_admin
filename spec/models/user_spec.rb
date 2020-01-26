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
  it {should have_many(:user_nodes)}
  it {should have_many(:nodes)}
  it {should have_one(:instance)}

  context 'when double name' do
    let!(:tree1)  {FactoryGirl.create :tree}
    let!(:tree2)  {FactoryGirl.create :tree}
    let!(:user1) {FactoryGirl.create :user, name: 'user1', tree: tree1}
    let!(:user2) {FactoryGirl.create :user, name: 'user2', tree: tree2}
    let!(:user11) {FactoryGirl.build :user, name: 'user1', tree: tree1}
    let!(:user12) {FactoryGirl.build :user, name: 'user1', tree: tree2}
    let!(:user11_1) {FactoryGirl.build :user, name: 'user1_1', tree: tree1}


    it { expect(user11).to be_invalid }
    it { expect(user12).to be_valid }
    it { expect(user11_1).to be_valid }
  end
end

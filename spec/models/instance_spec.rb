require 'rails_helper'

describe Instance do
  describe 'factory' do
    let!(:instance) {FactoryGirl.create :instance}

    # Factories
    it { expect(instance).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:state) }

    # noinspection RubyResolve
    it { expect(FactoryGirl.build(:instance, name: "")).to be_invalid}
    it { expect(FactoryGirl.build(:instance, name: "thename1234")).to be_valid}
    # noinspection RubyResolve
    it { expect(FactoryGirl.build(:instance, name: "the_name1234")).to be_valid}
    it { expect(FactoryGirl.build(:instance, name: "the-name1234")).to be_invalid}
    it { expect(FactoryGirl.build(:instance, name: "2thename1234")).to be_invalid}
    it { expect(FactoryGirl.build(:instance, name: "a2the.name.1234")).to be_valid}
    it { expect(FactoryGirl.build(:instance, name: "12343424123412")).to be_invalid}

    # Relationships
    it {should have_many(:trees)}
    it {should have_many(:nodes)}
  end
end

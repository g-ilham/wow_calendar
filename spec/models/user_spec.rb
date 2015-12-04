require 'rails_helper'

describe User, type: :model do

  let(:first_name) { "Ilgam" }
  let(:user) { FactoryGirl.create(:user, first_name: first_name) }

  subject { user }

  it { is_expected.to have_many(:events).dependent(:destroy) }

  it do
    is_expected.to validate_length_of(:first_name).
      is_at_least(2).is_at_most(100)
  end

  it do
    is_expected.to validate_length_of(:last_name).
      is_at_least(2).is_at_most(100)
  end

  it { is_expected.to allow_value(nil).for(:first_name) }
  it { is_expected.to allow_value(nil).for(:last_name) }
  it { is_expected.to allow_value("").for(:first_name) }
  it { is_expected.to allow_value("").for(:last_name) }

  it "#first_name returns a string" do
    expect(user.first_name).to match "Ilgam"
  end
end

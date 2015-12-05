require 'rails_helper'

describe User, type: :model do

  let(:user) { FactoryGirl.create(:user, first_name: "Ilgam") }

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

  it { is_expected.to allow_value("john@example.com", "lambda@gusiev.com").for(:email) }
  it { is_expected.to_not allow_value("invalid", nil, "a@b", "john@.com").for(:email) }
  it { is_expected.to allow_value("Таня2", "Tanya 3", nil, "").for(:first_name) }
  it { is_expected.to allow_value("Таня2", "Tanya 3", nil, "").for(:last_name) }
  it { is_expected.to_not allow_value("Tany@", "john@.-#com").for(:first_name) }
  it { is_expected.to_not allow_value("Tany@", "john@.-#com").for(:last_name) }

  it "#first_name returns a string" do
    expect(user.first_name).to match "Ilgam"
  end
end

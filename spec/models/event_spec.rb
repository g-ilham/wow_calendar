require 'rails_helper'

describe Event, type: :model do

  let(:event) { FactoryGirl.create(:event, title: "День рождение") }

  subject { event }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:childs).class_name('Event').with_foreign_key('parent_id') }
  it { is_expected.to belong_to(:parent).class_name('Event').with_foreign_key('parent_id') }

  it do
    is_expected.to validate_length_of(:title).
      is_at_least(2).is_at_most(100)
  end

  it do
    should validate_inclusion_of(:repeat_type).
      in_array(Event::REPEAT_TYPES)
  end

  it { is_expected.to allow_value("Встреча1", "Встреча 3").for(:title) }
  it { is_expected.to_not allow_value("Встреча@", "john@.-#com", nil, "").for(:title) }

  it "#title returns a string" do
    expect(event.title).to match "День рождение"
  end
end

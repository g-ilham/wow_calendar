require "rails_helper"

describe Events::SettingsUpdator do
  describe "will be update nitofocations when not change event attrs" do
    let(:event) { FactoryGirl.create(:event) }
    let(:prev_event_attr) {
      {
        starts_at: event.starts_at,
        repeat_type: event.repeat_type,
        updated_at: event.updated_at
      }
    }
    let(:message) { Users::Notifications::OPTIONS[:in_fifteen_minutes] }

    before do
      event.update(title: "Йога")
      event.user.toggle(:in_fifteen_minutes)
      event.user.toggle(:in_hour)
      Events::SettingsUpdator.new(event, prev_event_attr).run
    end

    it "create scheduled jobs" do
      expect(EventMailer.instance_method :notify).to be_delayed(event, message)
    end
  end
end

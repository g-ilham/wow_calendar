require "rails_helper"

describe Events::SettingsUpdator do
  describe do
    let(:event) { FactoryGirl.create(:event) }
    let(:message) { Users::Notifications::OPTIONS[:in_fifteen_minutes] }
    let!(:prev_event_attr) {
      {
        starts_at: event.starts_at,
        repeat_type: event.repeat_type,
        updated_at: event.updated_at
      }
    }

    context "will update user notifications job and schedule next event job" do
      before do
        update_persisted_event_and_user
        event.update(repeat_type: 'every_week')
        Events::SettingsUpdator.new(event, prev_event_attr).run
      end

      it "notification with notifying by 15 minutes and event with repeating every week" do
        expect(EventMailer.instance_method :notify).to be_delayed(event, message)
        expect(Events::ScheduleNextEvent.method :create_clone).to be_delayed(event.id)
      end
    end

    context "will update user notifications job when not change event attrs" do
      before do
        update_persisted_event_and_user
        Events::SettingsUpdator.new(event, prev_event_attr).run
      end

      it "only notification with notifying by 15 minutes" do
        expect(EventMailer.instance_method :notify).to be_delayed(event, message)
      end
    end
  end

  private

  def update_persisted_event_and_user
    event.update(title: "Йога")
    event.user.toggle(:in_fifteen_minutes)
    event.user.toggle(:in_hour)
  end
end

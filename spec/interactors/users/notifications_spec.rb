require "rails_helper"

describe Users::Notifications do
  describe "will be updating planned user notifications" do
    let(:event) { FactoryGirl.create(:event) }
    let(:message) { Users::Notifications::OPTIONS[:in_fifteen_minutes] }
    let!(:prev_notifications_options) { event.user.notifications_options }

    before do
      event.user.toggle(:in_fifteen_minutes)
      event.user.toggle(:in_hour)
      Users::Notifications.new(event.user, prev_notifications_options).run
    end

    it "with a delay of 15 minutes before the event" do
      expect(EventMailer.instance_method :notify).to be_delayed(event, message)
    end
  end
end

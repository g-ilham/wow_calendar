require "rails_helper"

describe Events::ScheduleNextEvent do
  describe "will be delay creating event" do
    let(:event) { FactoryGirl.create(:event, :repeated_every_day)}

    before do
      Events::ScheduleNextEvent.new(event, event.id).run
    end

    it "create next event with delay" do
      expect(Events::ScheduleNextEvent.method :create_clone).to be_delayed(event.id)
    end
  end

  describe "not will be delay creating event but create event now" do
    let(:event) { FactoryGirl.create(:event, :repeated_every_day)}

    before do
      Events::ScheduleNextEvent.new(event, event.id).run
    end

    it "create next event now" do
      expect(Events::ScheduleNextEvent.method :create_clone).to_not be_delayed
      expect(Event.count).to eq(2)
    end
  end

  describe "not will be delay creating event" do
    let(:event) { FactoryGirl.create(:event)}

    before do
      Events::ScheduleNextEvent.new(event, event.id).run
    end

    it "not create next event with delay" do
      expect(Events::ScheduleNextEvent.method :create_clone).to_not be_delayed(event.id)
    end
  end
end

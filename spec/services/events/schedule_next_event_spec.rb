require "rails_helper"

describe Events::ScheduleNextEvent do
  describe "will be delay creating new next event" do
    let(:event) { FactoryGirl.create(:event, :repeated_every_week)}

    before do
      Events::ScheduleNextEvent.new(event, event.id).run
    end

    it "with delay" do
      expect(Events::ScheduleNextEvent.method :create_clone).to be_delayed(event.id)
      expect(Event.count).to eq(1)
    end
  end

  describe "creates next event now and will be delay creating new next event" do
    let(:event) { FactoryGirl.create(:event, :repeated_every_day)}

    before do
      Events::ScheduleNextEvent.new(event, event.id).run
    end

    it "with delay and without create now" do
      expect(Events::ScheduleNextEvent.method :create_clone).to be_delayed(event.id)
      expect(Event.count).to eq(2)
    end
  end

  describe "will not delay the creation of the next event and does not create it now" do
    let(:event) { FactoryGirl.create(:event)}

    before do
      Events::ScheduleNextEvent.new(event, event.id).run
    end

    it "without delay and without create now" do
      expect(Events::ScheduleNextEvent.method :create_clone).to_not be_delayed(event.id)
      expect(Event.count).to eq(1)
    end
  end
end

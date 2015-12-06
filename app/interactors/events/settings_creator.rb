class Events::SettingsCreator
  attr_accessor :event,
                :parent_id

  def initialize(event)
    self.event = event
    self.parent_id = event.parent_id || event.id
  end

  def run
    Events::Notifications.new(event).run
    Events::ScheduleNextEvent.new(event, parent_id).run
  end

  def success?
    event.present?
  end
end

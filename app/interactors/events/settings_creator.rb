class Events::SettingsCreator
  attr_accessor :event,
                :user,
                :parent_id,
                :user_notifications_helper

  def initialize(event)
    self.event = event
    self.user = event.user
    self.parent_id = event.parent_id || event.id
    self.user_notifications_helper = Users::Notifications.new(user,
                                                              user.notifications_options)
  end

  def run
    user_notifications_helper.schedule_mailers(event)
    Events::ScheduleNextEvent.new(event, parent_id).run
  end

  def success?
    event.present?
  end
end

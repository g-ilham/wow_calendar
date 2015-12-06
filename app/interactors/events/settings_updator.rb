class Events::SettingUpdator
  attr_accessor :event,
                :user,
                :childs,
                :last_child,
                :parent_id,
                :prev_event_attr

  def initialize(event, prev_event_attr)
    self.event = event
    self.user = event.user
    self.prev_event_attr = prev_event_attr
    self.childs = event.childs_with_parent
                       .where.not(id: event.id)
    self.last_child = childs.last
    self.parent_id = event.parent_id || event.id

    self.user_notifications_helper = Users::Notifications.new(user,
                                                              user.notifications_options)
  end

  def run
    if event_attrs_changed?
      Events::CleanUpScheduledJobs.clean(event.id, parent_id)
      user_notifications_helper.schedule_mailers(event)
      Events::ScheduleNextEvent.new(last_child, parent_id).run
    else
      event.touch(:updated_at) if updated_at_not_changed?
      Events::CleanUpScheduledJobs.new(event.id,'EventMailer')
      user_notifications_helper.schedule_mailers(event)

      event
    end
  end

  def success?
    event.present?
  end

  def event_attrs_changed?
    starts_at_changed? || repeat_type_changed?
  end

  def starts_at_changed?
    event.starts_at != prev_event_attr[:starts_at]
  end

  def repeat_type_changed?
    event.repeat_type != prev_event_attr[:repeat_type]
  end

  def updated_at_not_changed?
    event.updated_at == prev_event_attr[:updated_at]
  end
end

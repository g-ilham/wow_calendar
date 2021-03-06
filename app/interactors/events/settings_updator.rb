class Events::SettingsUpdator
  attr_reader :event,
              :user,
              :childs,
              :last_child,
              :parent_id,
              :prev_event_attr,
              :user_notifications_helper

  def initialize(event, prev_event_attr)
    @event = event
    @user = event.user
    @prev_event_attr = prev_event_attr
    @childs = event.childs_with_parent
    @last_child = childs.last
    @parent_id = event.parent_id || event.id

    @user_notifications_helper = Users::Notifications.new(user,
                                                              user.notifications_options)
  end

  def run
    if event_attrs_changed?
      Events::CleanUpScheduledJobs.clean(event.id, parent_id)
      user_notifications_helper.schedule_mailers(event)
      Events::ScheduleNextEvent.new(last_child, parent_id).run
    else
      event.touch(:updated_at) if updated_at_not_changed?
      Events::CleanUpScheduledJobs.new(event.id,'EventMailer').run
      user_notifications_helper.schedule_mailers(event)

      event
    end
  end

  def success?
    event.present?
  end

  private

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

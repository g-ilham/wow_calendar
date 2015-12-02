require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"

class Events::RecurringWithNotifications

  attr_reader :event,
              :childs,
              :last_child,
              :action_name,
              :parent_id,
              :res,
              :prev_event_attr

  def initialize(event, action_name, prev_event_attr)
    @event = event
    @prev_event_attr = prev_event_attr
    @action_name = action_name
  end

  def base_handle
    Rails.logger.info" [ RecurringWithNotifications | START ] action_name: #{action_name}"

    if action_name == "create"
      Rails.logger.info"  [ RecurringWithNotifications ] only create"
      Events::Notifications.new(event).run
      Events::DelayCreateClone.new(event).res

    elsif changed_event_attrs || action_name == "destroy"
      Rails.logger.info"  [ RecurringWithNotifications ] only update_recurring_and_notifications"
      update_recurring_and_notifications!
    else
      Rails.logger.info"  [ RecurringWithNotifications ] only update without change event some attrs"
      event.touch(:updated_at) if updated_at_not_changed
      Events::Notifications.new(event).update_for_event!
      event
    end
  end

  def changed_event_attrs
    starts_at_changed || repeat_type_changed
  end

  def starts_at_changed
    prev_event_attr && event.starts_at != prev_event_attr[:starts_at]
  end

  def repeat_type_changed
    prev_event_attr && event.repeat_type != prev_event_attr[:repeat_type]
  end

  def updated_at_not_changed
    prev_event_attr && event.updated_at == prev_event_attr[:updated_at]
  end

  def update_recurring_and_notifications!
    Rails.logger.info"\n"
    Rails.logger.info" [ RecurringWithNotifications ] update recurring and notifications"
    Rails.logger.info"   [ RecurringWithNotifications ] event_parent_id #{parent_id}"

    get_childs_and_last_child
    Events::Notifications.new(event, action_name).update_for_event!
    update_recurring!
  end

  def get_childs_and_last_child
    @childs = event.childs_with_parent
    @last_child = childs.last
  end

  def update_recurring!
    Rails.logger.info"\n"
    Rails.logger.info"   [ RecurringWithNotifications | REMOVE RECURRNIG ] with parent_id #{parent_id}"
    parent_id = (last_child.parent_id || last_child.id)
    Events::CleanScheduledJobs.new(parent_id,
                                    "Events::DelayCreateClone")

    if action_name == 'destroy'
      check_childs
    else
      Rails.logger.info"\n"
      Rails.logger.info"   [ RecurringWithNotifications ] call update recurring for #{event.inspect}"

      Events::DelayCreateClone.new(last_child).res
    end
  end

  def check_childs
    @childs = childs.to_a.delete_if { |child| child.id = event.id }

    if childs.size > 0
      destroy_event_with_delay!
    else
      event.destroy; nil
    end
  end

  def destroy_event_with_delay!
    Rails.logger.info"\n"
    Rails.logger.info"   [ RecurringWithNotifications ] call update recurring for #{childs.last.inspect}"

    event.destroy
    returned_event = Events::DelayCreateClone.new(childs.last).res
    Events::Notifications.new(returned_event).run if returned_event.new_record?
    returned_event
  end
end

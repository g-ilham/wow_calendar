class Recurring
  require 'sidekiq/api'

  attr_reader :event,
              :current_user,
              :childs,
              :last_child,
              :action_name,
              :starts_at_changed,
              :res

  def initialize(current_user, event, action_name, starts_at_changed)
    @current_user = current_user
    @event = event
    @action_name = action_name
    @starts_at_changed = starts_at_changed
    require_dependency "#{Rails.root}/app/mailers/event_mailer"
    update_recurring_and_notifications
  end

  def update_recurring_and_notifications
    Rails.logger.info"\n"
    Rails.logger.info" [ Recurring | START ] update recurring and notifications"

    get_childs_and_last_child
    Rails.logger.info"  [ Recurring ] last child #{last_child.inspect}"

    CleanScheduledJobs.new(current_user,
                            last_child, 'Sidekiq::Extensions::DelayedClass')
    update_notifications

    @res = if action_name == "destroy"
      remove_action
    else
      Rails.logger.info"\n"
      Rails.logger.info"  [ Recurring ] call update recurring for #{last_child.inspect}"
      last_child.delay_creating_clone!
    end
  end

  def remove_action
    @childs = childs.to_a.delete_if { |e| e.id == event.id }

    if childs.size > 0
      Rails.logger.info"\n"
      Rails.logger.info"  [ Recurring ] call update recurring for #{childs.last.inspect}"
      returned_event = childs.last.delay_creating_clone!
      if returned_event.new_record?
        EventNotifications.new(current_user, returned_event)
      end
      returned_event
    end
  end

  def get_childs_and_last_child
    @childs = event.childs_with_parent
    @last_child = childs.last
  end

  def update_notifications
    Rails.logger.info"\n"
    Rails.logger.info"  [ Recurring | REMOVE NOTIFICATIONS ] for #{event.inspect}"
    CleanScheduledJobs.new(current_user,
                            event, 'Sidekiq::Extensions::DelayedMailer')

    if action_name != "destroy"
      Rails.logger.info"  [ Recurring | UPDATE NOTIFICATIONS ] for #{event.inspect}"
      EventNotifications.new(current_user, event)
    end
  end
end
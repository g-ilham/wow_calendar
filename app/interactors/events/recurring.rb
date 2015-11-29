require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"
class Events::Recurring
  attr_reader :event,
              :current_user,
              :childs,
              :last_child,
              :action_name,
              :res,
              :last_child_parent_id

  def initialize(current_user, event, action_name)
    @current_user = current_user
    @event = event
    @action_name = action_name
    update_recurring_and_notifications
  end

  def update_recurring_and_notifications
    Rails.logger.info"\n"
    Rails.logger.info" [ Recurring | START ] update recurring and notifications"

    get_childs_and_last_child
    Rails.logger.info"  [ Recurring ] last child #{last_child.inspect}"
    Rails.logger.info"  [ Recurring ] last_child_parent_id #{last_child_parent_id}"

    Events::CleanScheduledJobs.new(current_user,
                                    last_child_parent_id, 'Sidekiq::Extensions::DelayedClass')
    # update_notifications
    @res = delay_job!
  end

  def get_childs_and_last_child
    @childs = event.childs_with_parent
    @last_child = childs.last
    @last_child_parent_id = (last_child.parent_id || last_child.id)
  end

  def update_notifications
    Rails.logger.info"\n"
    Rails.logger.info"  [ Recurring | REMOVE NOTIFICATIONS ] for #{event.inspect}"

    Events::CleanScheduledJobs.new(current_user,
                                    event,
                                    'Sidekiq::Extensions::DelayedMailer')

    if action_name != "destroy"
      Rails.logger.info"  [ Recurring | UPDATE NOTIFICATIONS ] for #{event.inspect}"

      Events::Notifications.new(current_user, event)
    end
  end

  def delay_job!
    if action_name == "destroy"
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
        # Events::Notifications.new(current_user, returned_event)
      end
      returned_event
    end
  end
end

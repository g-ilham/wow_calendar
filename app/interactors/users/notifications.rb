require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"

class Users::Notifications

  OPTIONS = {
    in_fifteen_minutes: 'Через пятнадцать минут у вас событие: ',
    in_hour: 'Через час у вас событие: ',
    in_day: 'Через день у вас событие: '
  }

  attr_accessor :user,
                :selected_at_least_of_one_option,
                :prev_notifications_options

  def initialize(user, prev_notifications_options)
    self.user = user
    self.selected_at_least_of_one_option = user.notifications_options.any?(&:present?)
    self.prev_notifications_options = prev_notifications_options
  end

  def run
    run_update_for_collection! if notification_options_updated?
  end

  def schedule_mailers(event)
    selected_options.each do |key, value|
      sending_ops = get_sending_time(key, event)

      if sending_ops > Time.zone.now
        EventMailer.delay_until(sending_ops)
                   .notify(event, value)
      end
    end
  end

  private

  def run_update_for_collection!
    user.events.each do |event|
      Events::CleanUpScheduledJobs.new(event.id, 'EventMailer')

      if selected_at_least_of_one_option
        schedule_mailers(event)
      end
    end
  end

  def selected_options
    OPTIONS.select do |k, _v|
      user.public_send(k).present?
    end
  end

  def get_sending_time(key, event)
    case key.to_s
    when 'in_fifteen_minutes'
      event.starts_at - 15.minutes
    when 'in_hour'
      event.starts_at - 1.hour
    when 'in_day'
      event.starts_at - 1.day
    end
  end

  def notification_options_updated?
    user.notifications_options != prev_notifications_options
  end
end

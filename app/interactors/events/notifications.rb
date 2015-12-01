require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"

class Events::Notifications

  OPTIONS = {
    in_fifteen_minutes: 'Через пятнадцать минут у вас событие: ',
    in_hour: 'Через час у вас событие: ',
    in_day: 'Через день у вас событие: '
  }

  attr_reader :event,
              :action_name

  def initialize(event, action_name="update")
    @event = event
    @action_name = action_name
  end

  def run
    Rails.logger.info"\n"
    OPTIONS.each do |key, value|
      key = key.to_s
      sending_ops = get_sending_time(key)
      Rails.logger.info"   [ Events::Notifications ] user conf #{key} sending time #{sending_ops}"

      if sending_ops > event.updated_at && event.user.send(key)

        Rails.logger.info"    [ Events::Notifications ] send #{key}"

        EventMailer.delay_until(sending_ops).notify(event, value)
      end
    end
  end

  def get_sending_time(key)
    case key
    when 'in_fifteen_minutes'
      event.starts_at - 15.minutes
    when 'in_hour'
      event.starts_at - 1.hour
    when 'in_day'
      event.starts_at - 1.day
    end
  end

  def update_notifications!
    Rails.logger.info"\n"
    Rails.logger.info"   [ Notifications | REMOVE NOTIFICATIONS ] for #{event.inspect}"
    Events::CleanScheduledJobs.new(event.id,
                                    'EventMailer')
    Rails.logger.info"\n"
    Rails.logger.info"   [ Notifications ] action_name #{action_name}"

    if action_name != "destroy"
      run
    end
  end
end

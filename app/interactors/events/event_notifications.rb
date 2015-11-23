module Events
  class EventNotifications
    attr_reader :user, :event

    OPTIONS = {
      in_fifteen_minutes: 'Через пятнадцать минут у вас событие: ',
      in_hour: 'Через час у вас событие: ',
      in_day: 'Через день у вас событие: '
    }

    def initialize(user, event)
      @user = user
      @event = event
      run
    end

    def run
      OPTIONS.each do |key, value|
        key = key.to_s
        sending_ops = get_sending_time(key)
        puts "[ EventNotifications ] user conf #{key} sending time #{sending_ops}"

        if sending_ops > event.updated_at && user.send(key)

          puts "  [ EventNotifications ] send #{key}"

          EventMailer.delay_until(sending_ops).send_notify(event,
                                                              value)
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
  end
end

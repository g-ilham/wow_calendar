require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"

class Events::DelayCreateClone

  attr_reader :event,
              :event_parent_id,
              :base_log_name,
              :res

  def initialize(event)
    @event = event
    delay_creating_clone!
  end

  def delay_creating_clone!
    @base_log_name = "  [ DelayCreateClone | DELAY CREATING CLONE ]"
    @event_parent_id = (event.parent_id || event.id)

    Rails.logger.info"\n"
    Rails.logger.info"#{base_log_name} event repeat #{event.repeat_type}"
    Rails.logger.info"#{base_log_name} event parent_id #{event_parent_id}"

    @res = if event.repeat_type != 'not_repeat'
      check_create_now_or_delay
    else
      event
    end
  end

  def check_create_now_or_delay
    create_clone_time = Events::DelayCreateClone.get_clone_date_params(event)
    delayed_time = (create_clone_time[:starts_at] - 1.day).beginning_of_day

    Rails.logger.info"#{base_log_name} create clone time #{delayed_time}"
    Rails.logger.info"#{base_log_name} create clone time parsed #{Date.parse("#{delayed_time}")}"

    if Date.parse("#{delayed_time}") > Date.parse("#{Time.zone.now}")

      Rails.logger.info"#{base_log_name} create with delayed"

      Events::DelayCreateClone.delay_until(delayed_time).create_clone(event_parent_id)
      event
    else
      Rails.logger.info"#{base_log_name} create now"

      Events::DelayCreateClone.create_clone(event_parent_id)
    end
  end

  class << self

    def get_repeat_time(event)
      case event.repeat_type
      when 'every_day'
        1.day
      when 'every_week'
        1.week
      when 'every_month'
        1.month
      when 'every_year'
        1.year
      end
    end

    def duplicate_attrs(event)
      create_clone_time = Events::DelayCreateClone.get_clone_date_params(event)
      dup = event.dup
      dup.starts_at = create_clone_time[:starts_at]
      dup.ends_at = create_clone_time[:ends_at]
      dup.parent_id = (event.parent_id || event.id); dup
    end

    def get_clone_date_params(event)
      repeat_time = Events::DelayCreateClone.get_repeat_time(event)
      hash = { starts_at: event.starts_at + repeat_time, ends_at: event.ends_at }

      if event.ends_at
        hash[:ends_at] = event.ends_at + repeat_time
      end
      hash
    end

    def create_clone(parent_id)
      last_event = Event.childs_with_parent(parent_id).last

      Rails.logger.info"  [ DelayCreateClone | CREATE CLONE ] last event for duplicate #{last_event.inspect}"

      dup = Events::DelayCreateClone.duplicate_attrs(last_event)
      Rails.logger.info"  [ DelayCreateClone | CREATE CLONE ] duplicate last event AFTER: #{dup.inspect}"

      if dup.save!
        Events::Notifications.new(dup).run
        Events::DelayCreateClone.new(dup); dup
      end
    end
  end
end

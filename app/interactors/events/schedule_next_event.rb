require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"

class Events::ScheduleNextEvent

  attr_accessor :event,
                :parent_id

  def initialize(event, parent_id)
    self.event = event
    self.parent_id = parent_id
  end

  def run
    event.repeat_type != 'not_repeat' ? next_event : event
  end

  def next_event
    next_event_ops = self.class.get_next_event_ops(event)
    next_event_time = (next_event_ops[:starts_at] - 1.day).beginning_of_day

    if next_event_time.to_date > Date.today
      self.class.delay_until(next_event_time)
                .create_clone(parent_id)

      event
    else
      self.class.create_clone(parent_id)
    end
  end

  class << self
    def get_next_event_ops(event)
      delay = repeat_time(event)
      ops = { starts_at: event.starts_at + delay }

      if event.ends_at.present?
        ops[:ends_at] = event.ends_at + delay
      end

      ops
    end

    def repeat_time(event)
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

    def create_clone(parent_id)
      last_event = Event.childs_with_parent(parent_id).last
      dup = clone_attrs(last_event)

      if dup.save!
        Events::Notifications.new(dup).run
        Events::ScheduleNextEvent.new(dup, parent_id).run

        dup
      end
    end

    def clone_attrs(event)
      dup = event.dup
      dup.attributes = get_next_event_ops(event)
      dup.parent_id = event.parent_id || event.id

      dup
    end
  end
end

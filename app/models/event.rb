require_dependency "#{Rails.root}/app/mailers/event_mailer"
class Event < ActiveRecord::Base

  REPEAT_TYPES = [
    'every_day',
    'every_week',
    'every_month',
    'every_year',
    'not_repeat'
  ]

  TITLE_REGEXP = /\A[а-яА-Яa-zA-Z0-9\s]+\z/

  begin :asssociations
    belongs_to :user
    belongs_to :parent, class_name: "Event", foreign_key: 'parent_id'
    has_many :childs, class_name: "Event", foreign_key: 'parent_id', validate: false
  end

  begin :scopes
    default_scope { order(starts_at: :asc) }
    scope :childs_with_parent, -> (parent_id) { where("(id=?) OR (parent_id=?)",
                                                       parent_id, parent_id) }
  end

  begin :validations
    validates :title, format: { with: TITLE_REGEXP  }, if: 'self.title.present?'
    validates :title, length: { minimum: 2, maximum: 100 }
    validates :repeat_type, inclusion: { in: REPEAT_TYPES }, allow_nil: true
    validates_datetime :starts_at, on_or_after: lambda { Time.zone.now.strftime("%F %H:%M") }
    validates_datetime :ends_at, on_or_after: :starts_at, if: "!self.all_day"
  end

  begin :recurrings

    def delay_creating_clone!
      base_log_name = "  [ Recurring | DELAY CREATING CLONE ]"
      event_parent_id = (self.parent_id || self.id)

      Rails.logger.info"\n"
      Rails.logger.info"#{base_log_name} event repeat #{repeat_type}"
      Rails.logger.info"#{base_log_name} event parent_id #{event_parent_id}"

      if repeat_type != 'not_repeat'
        check_create_now_or_delay(base_log_name, event_parent_id)
      else
        Events::CleanScheduledJobs.new(event_parent_id,
                                        'Sidekiq::Extensions::DelayedClass')
        self
      end
    end

    def check_create_now_or_delay(base_log_name, event_parent_id)
      create_clone_time = (get_clone_date_params[:starts_at] - 1.day).beginning_of_day

      Rails.logger.info"#{base_log_name} create clone time #{Date.parse("#{create_clone_time}")}"

      if Date.parse("#{create_clone_time}") > Date.parse("#{Time.zone.now}")

        Rails.logger.info"#{base_log_name} create with delayed"

        Event.delay_until(create_clone_time).create_clone(event_parent_id)
        self
      else
        Rails.logger.info"#{base_log_name} create now"

        Event.create_clone(event_parent_id)
      end
    end

    def get_repeat_type
      case self.repeat_type
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

    def duplicate_attrs
      dup = self.dup
      dup.starts_at = self.get_clone_date_params[:starts_at]
      dup.ends_at = self.get_clone_date_params[:ends_at]
      dup.parent_id = (self.parent_id || self.id); dup
    end

    def get_clone_date_params
      repeat_type = self.get_repeat_type
      hash = { starts_at: self.starts_at + repeat_type, ends_at: self.ends_at }

      if self.ends_at
        hash[:ends_at] = self.ends_at + repeat_type
      end
      hash
    end

    def childs_with_parent
      parent_id = self.parent_id
      if !parent_id
        parent_id = self.id
      end
      Event.childs_with_parent(parent_id)
    end
  end

  def empty_message
    [
      I18n.t(:activerecord)[:models][:event] + ' ' +
      I18n.t(:errors)[:messages][:empty]
    ]
  end

  class << self
    def create_clone(parent_id)
      last_event = Event.childs_with_parent(parent_id).last

      Rails.logger.info"  [ Recurring | CREATE CLONE ] last event for duplicate #{last_event.inspect}"

      dup = last_event.duplicate_attrs
      Rails.logger.info"  [ Recurring | CREATE CLONE ] duplicate last event AFTER: #{dup.inspect}"

      if dup.save!
        # Events::Notifications.new(dup)
        dup.delay_creating_clone!; dup
      end
    end
  end
end

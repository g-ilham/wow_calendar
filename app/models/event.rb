class Event < ActiveRecord::Base
  require_dependency "#{Rails.root}/app/mailers/event_mailer"
  belongs_to :user
  belongs_to :parent, class_name: "Event", foreign_key: 'parent_id'
  has_many :childs, class_name: "Event", foreign_key: 'parent_id', validate: false

  REPEAT_TYPES = [
    'every_day',
    'every_week',
    'every_month',
    'every_year',
    'not_repeat'
  ]

  begin :scopes
    default_scope { order(starts_at: :asc) }
    scope :childs_with_parent, -> (parent_id) { where("(id=#{parent_id}) OR (parent_id=#{parent_id})") }
  end

  begin :validations
    validates :title, format: { with: /[а-яА-Яa-zA-Z]+/ }, if: 'self.title.present?'
    validates :title, length: { minimum: 2, maximum: 100 }
    validates :repeat_type, inclusion: { in: REPEAT_TYPES }, allow_nil: true
    validates_datetime :starts_at, on_or_after: lambda { Time.zone.now.strftime("%F %H:%M") }
    validates_datetime :ends_at, on_or_after: :starts_at, if: "!self.all_day"
  end

  begin :recurrings

    def delay_creating_clone!
      Rails.logger.info"\n"
      Rails.logger.info"  [ Recurring | DELAY CREATING CLONE ] event repeat #{self.repeat_type != 'not_repeat'} "

      if self.repeat_type != 'not_repeat'
        create_clone_time = (self.get_clone_date_params[:starts_at] - 1.day).beginning_of_day

        Rails.logger.info"  [ Recurring | DELAY CREATING CLONE ] create clone time #{create_clone_time}"
        Rails.logger.info"  [ Recurring | DELAY CREATING CLONE ] create clone day #{create_clone_time.day}"

        if create_clone_time.strftime("%D") > Time.zone.now.strftime("%D")
          Rails.logger.info"  [ Recurring | DELAY CREATING CLONE ] create with delayed"

          Event.delay_until(create_clone_time).create_clone(self.user, self)
          self
        else
          Rails.logger.info"  [ Recurring | DELAY CREATING CLONE ] create now"

          Event.create_clone(self.user, self)
        end
      else
        CleanScheduledJobs.new(self.user,
                                self, 'Sidekiq::Extensions::DelayedClass')
        self
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

  def empty_event_message
    [
      I18n.t(:activerecord)[:models][:event] + ' ' +
      I18n.t(:errors)[:messages][:empty]
    ]
  end

  class << self
    def create_clone(current_user, event)
      Rails.logger.info"  [ Recurring | CREATE CLONE ] event for duplicate #{event.inspect}"

      if event

        dup = event.duplicate_attrs
        Rails.logger.info"  [ Recurring | CREATE CLONE ] duplicate event AFTER: #{dup.inspect}"

        if dup.save!
          EventNotifications.new(current_user, dup)
          dup.delay_creating_clone!; dup
        end
      else
        Rails.logger.info"  [ Recurring | CREATE CLONE ] Event not present"
      end
    end
  end
end

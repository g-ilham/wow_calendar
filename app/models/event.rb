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

  begin :callbacks
    before_validation :trim_title
    before_validation :parse_event_date
  end

  def trim_title
    self.title = self.title.strip()
  end

  def parse_event_date
    self.starts_at = Time.zone.parse(self.starts_at.to_s)
    self.ends_at = Time.zone.parse(self.ends_at.to_s)
  end

  def childs_with_parent
    parent_id = self.parent_id
    if !parent_id
      parent_id = self.id
    end
    Event.childs_with_parent(parent_id)
  end

  def empty_message
    [
      I18n.t(:activerecord)[:models][:event] + ' ' +
      I18n.t(:errors)[:messages][:empty]
    ]
  end
end

class Event < ActiveRecord::Base

  REPEAT_TYPES = [
    'every_day',
    'every_week',
    'every_month',
    'every_year',
    'not_repeat'
  ]

  belongs_to :user
  belongs_to :parent, class_name: "Event",
                      foreign_key: 'parent_id'

  has_many :childs, class_name: "Event",
                    foreign_key: 'parent_id'

  default_scope { order(starts_at: :asc) }

  scope :childs_with_parent, -> (parent_id) do
    where.any_of(id: parent_id, parent_id: parent_id)
  end

  validates :title, format: { with: User::NAME_REGEXP },
                    if: 'self.title.present?'
  validates :title, length: { minimum: 2, maximum: 100 }
  validates :repeat_type, inclusion: { in: REPEAT_TYPES }

  validates_datetime :starts_at, on_or_after: lambda { Time.zone.now.strftime("%F %H:%M") }
  validates_datetime :ends_at, after: :starts_at,
                               if: :need_to_validate_ends_at?

  before_validation :trim_title, if: "self.title.present?"
  before_validation :parse_event_date

  def childs_with_parent
    self.class.childs_with_parent(parent_id || id)
  end

  def need_to_validate_ends_at?
    starts_at.present? && !self.all_day?
  end

  private

  def trim_title
    self.title = title.strip()
  end

  def parse_event_date
    self.starts_at = Time.zone.parse(starts_at.to_s)
    self.ends_at = Time.zone.parse(ends_at.to_s)
  end
end

class Event < ActiveRecord::Base
  belongs_to :user

  begin :validations
    validates :title, format: { with: /[а-яА-Яa-zA-Z]+/ }, if: 'self.title.present?'
    validates :title, length: { minimum: 2, maximum: 100 }
    validates_datetime :starts_at, on_or_after: :today
    validates_datetime :ends_at, on_or_after: :starts_at, unless: "self.all_day?"
  end
end

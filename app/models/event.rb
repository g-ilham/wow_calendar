class Event < ActiveRecord::Base
  belongs_to :user

  begin :validations
    validates :title, format: { with: /[а-яА-Яa-zA-Z]+/ }, if: 'self.title.present?'
    validates :title, length: { minimum: 2, maximum: 100 }
    validates_datetime :starts_at, on_or_after: lambda { Time.zone.now }
    validates_datetime :ends_at, on_or_after: :starts_at, if: "!self.all_day"
  end

  class << self
    def empty_event_message
      [
        I18n.t(:activerecord)[:models][:event] + ' ' +
        I18n.t(:errors)[:messages][:empty]
      ]
    end
  end
end

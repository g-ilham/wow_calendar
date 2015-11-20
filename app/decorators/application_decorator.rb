class ApplicationDecorator < Draper::Decorator
  delegate_all

  def created_at
    h.to_date(object.created_at)
  end
end

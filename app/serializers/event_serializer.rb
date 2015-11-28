class EventSerializer < ActiveModel::Serializer
  attributes :id, :start, :end, :allDay, :title, :repeat_type

  def start
    object.starts_at
  end

  def end
    object.ends_at
  end

  def allDay
    object.all_day
  end

  def title
    object.title
  end

  def repeat_type
    object.repeat_type
  end
end

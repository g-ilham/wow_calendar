class EventSerializer < ActiveModel::Serializer
  attributes :id, :start, :end, :allDay, :title

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
end

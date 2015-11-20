class EventSerializer < ActiveModel::Serializer
  attributes :id, :start, :end, :allDay, :title

  def start
    object.starts_at.to_s
  end

  def end
    object.ends_at.to_s
  end

  def allDay
    object.all_day
  end

  def title
    object.title
  end
end

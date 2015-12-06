class Events::Eliminator
  attr_accessor :event,
                :childs,
                :last_child,
                :parent_id

  def initialize(event)
    self.event = event
    self.childs = event.childs_with_parent
                       .where.not(id: event.id)
    self.last_child = childs.last
    self.parent_id = event.parent_id || event.id
  end

  def run
    Events::CleanUpScheduledJobs.clean(event.id, parent_id)
    persist!
  end

  def success?
    event.present?
  end

  private

  def persist!
    event.destroy
    next_event if childs.present?
  end

  def next_event
    Events::ScheduleNextEvent.new(last_child, parent_id).run
  end
end

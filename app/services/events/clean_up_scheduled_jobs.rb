require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"
require_dependency "#{Rails.root}/app/services/events/schedule_next_event"

class Events::CleanUpScheduledJobs
  attr_reader :event_id,
              :job_name,
              :target_jobs

  def initialize(event_id, job_name)
    @event_id = event_id
    @job_name = job_name

    @target_jobs = Sidekiq::ScheduledSet.new.select do |job|
      job_event_id = get_job_event_id(YAML.load(job.args[0])).to_s
      job_event_id.present? && job_event_id == event_id.to_s
    end
  end

  def run
    target_jobs.each do |job|
      job.delete
    end
  end

  private

  def get_job_event_id(job_yml)
    attrs = job_yml.last

    if job_yml.first.to_s == job_name
      if job_name == 'Events::ScheduleNextEvent'
        attrs.first
      else
        attrs.first.id
      end
    end
  end

  class << self
    def clean(event_id, parent_id)
      Events::CleanUpScheduledJobs.new(event_id, "EventMailer").run
      Events::CleanUpScheduledJobs.new(parent_id, "Events::ScheduleNextEvent").run
    end
  end
end

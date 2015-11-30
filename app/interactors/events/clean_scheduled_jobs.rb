require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"

class Events::CleanScheduledJobs

  attr_reader :parent_id,
              :job,
              :first_attr,
              :class_name,
              :scheduled

  def initialize(parent_id, class_name)
    @parent_id = parent_id
    @class_name = class_name
    @scheduled = Sidekiq::ScheduledSet.new
    clean
  end

  def clean
    Rails.logger.info"\n"
    scheduled.select do |job|
      attrs(job)
      Rails.logger.info"   [ CleanScheduledJobs ] #{class_name}"
      remove_job
    end
  end

  def attrs(job)
    @job = job
    EventMailer
    job_yml = YAML.load(job.args[0])
    get_first_attr(job_yml.last)
  end

  def get_first_attr(job_yml)
    @first_attr = if class_name == 'Sidekiq::Extensions::DelayedClass'
      job_yml.first
    else
      (job_yml.first.parent_id || job_yml.first.id)
    end
  end

  def remove_job
    if condition
      Rails.logger.info"     [ CleanScheduledJobs ] remove_job"
      job.delete
    end
  end

  def condition
    case class_name
    when 'Sidekiq::Extensions::DelayedClass'
      first_attr == parent_id
    when 'Sidekiq::Extensions::DelayedMailer'
      first_attr == parent_id
    end
  end
end

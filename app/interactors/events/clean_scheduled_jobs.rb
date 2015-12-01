require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"
require_dependency "#{Rails.root}/app/interactors/events/delay_create_clone"

class Events::CleanScheduledJobs

  attr_reader :parent_id,
              :job,
              :first_attr,
              :class_name,
              :job_yml,
              :scheduled

  def initialize(parent_id, class_name)
    @parent_id = parent_id
    @class_name = class_name
    @scheduled = Sidekiq::ScheduledSet.new
    Rails.logger.info"   [ CleanScheduledJobs ] run clean with #{class_name}"
    clean
  end

  def clean
    scheduled.map do |job|
      set_and_parse_attrs(job)
      remove_job
    end
  end

  def set_and_parse_attrs(job)
    @job = job
    @job_yml = YAML.load(job.args[0])
    @first_attr = get_first_attr(job_yml.last)
  end

  def get_first_attr(args)
    Rails.logger.info"\n"
    Rails.logger.info"   [ CleanScheduledJobs ] current class #{job_yml.first}"

    if job_yml.first.to_s == class_name
      if class_name == 'Events::DelayCreateClone'
        args.first
      else
        args.first.id
      end
    end
  end

  def remove_job
    if first_attr == parent_id
      Rails.logger.info"       [ CleanScheduledJobs ] remove_job"
      job.delete
    end
  end
end

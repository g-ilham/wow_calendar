class CleanScheduledJobs
  require 'sidekiq/api'

  attr_reader :current_user,
              :event,
              :job,
              :first_attr,
              :second_attr,
              :class_name,
              :scheduled

  def initialize(current_user, event, class_name)
    @current_user = current_user
    @event = event
    @class_name = class_name
    @scheduled = Sidekiq::ScheduledSet.new
    require_dependency "#{Rails.root}/app/mailers/event_mailer"
    clean
  end

  def clean
    puts "\n"
    scheduled.select do |job|
      attrs(job)
      puts "   [ CleanScheduledJobs ] #{class_name}"
      remove_job
    end
  end

  def attrs(job)
    @job = job
    EventMailer
    job_yml = YAML.load(job.args[0])
    @first_attr = job_yml.last.first.id
    @second_attr = job_yml.last.second.id if job_yml.last.second.class == Event
  end

  def remove_job
    if condition
      puts "     [ CleanScheduledJobs ] remove_job"
      job.delete
    end
  end

  def condition
    case class_name
    when 'Sidekiq::Extensions::DelayedClass'
      match_both_args
    when 'Sidekiq::Extensions::DelayedMailer'
      match_single_arg
    end
  end

  def match_both_args
    second_attr == event.id && first_attr == current_user.id
  end

  def match_single_arg
    first_attr == event.id
  end
end

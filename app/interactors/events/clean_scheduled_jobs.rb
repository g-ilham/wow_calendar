require 'sidekiq/api'
require_dependency "#{Rails.root}/app/mailers/event_mailer"
class Events::CleanScheduledJobs
  attr_reader :current_user,
              :parent_id,
              :job,
              :first_attr,
              :second_attr,
              :class_name,
              :scheduled

  def initialize(current_user, parent_id, class_name)
    @current_user = current_user
    @parent_id = parent_id
    @class_name = class_name
    @scheduled = Sidekiq::ScheduledSet.new
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
    @second_attr = job_yml.last.second
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
    second_attr == parent_id && first_attr == current_user.id
  end

  def match_single_arg
    first_attr == parent_id
  end
end

class EventMailer < ApplicationMailer
  def notify(event, message)
    @event = event
    @message = message
    @user = event.user.decorate
    @starts_at = Time.zone.parse("#{@event.starts_at}")
    @ends_at = @event.ends_at

    subject = I18n.t(:ru)[:mailers][:event][:subject][:notify]
    mail(to: event.user.email, subject: subject)
  end
end

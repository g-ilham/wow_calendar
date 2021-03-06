class EventMailer < ApplicationMailer
  def notify(event, message)
    @event = event
    @message = message
    @user = event.user.decorate
    @starts_at = Time.zone.parse("#{@event.starts_at}")
    @ends_at = Time.zone.parse("#{@event.ends_at}")

    subject = I18n.t(:mailers)[:event][:subject][:notify]
    mail(to: event.user.email, subject: subject)
  end
end

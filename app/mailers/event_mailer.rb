class EventMailer < ApplicationMailer
  def send_notify(event, message)
    if event.present?
      set_attrs(event, message)
      mail(to: event.user.email, subject: 'Напоминаем о грядущем событии')
    end
  end

  def set_attrs(event, message)
    @message = message
    @user = event.user
    @event = event
  end
end

class ContactMailer < ApplicationMailer

  SUPPORT_EMAIL = "ilgamgaysin@gmail.com"

  def notification(name, sender_email, message)
    @name = name
    @sender_email = sender_email
    @message = message

    mail to: SUPPORT_EMAIL, subject: "Письмо в техподдержку!"
  end
end

class TestMailer < ApplicationMailer
  def welcome(email)
    @email = email
    @subject = "Test mailer!"

    mail to: @email, subject: @subject
  end
end

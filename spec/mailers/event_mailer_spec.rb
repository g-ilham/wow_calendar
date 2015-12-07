require "rails_helper"

describe EventMailer do
  let(:event) { create :event }
  let(:sender_email) { "ilgamgaysin@gmail.com" }
  let(:message) { Users::Notifications::OPTIONS[:in_fifteen_minutes] }
  let(:subject) { I18n.t(:mailers)[:event][:subject][:notify] }

  describe "#notification" do
    let(:mail) { EventMailer.notify(event, message) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([event.user.email])
      expect(mail.from).to eq([sender_email])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(event.user.decorate.name_or_email)
      expect(mail.html_part.decoded).to match(event.title)
      expect(mail.html_part.decoded).to have_content(message)
      expect(mail.html_part.decoded).to have_content(event.starts_at.to_s)
      expect(mail.html_part.decoded).to have_content(event.ends_at.to_s)
    end
  end
end

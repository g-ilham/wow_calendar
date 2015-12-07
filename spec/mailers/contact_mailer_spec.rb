require "rails_helper"

describe ContactMailer do
  let(:name) { Faker::Name.first_name }
  let(:sender_email) { Faker::Internet.email }
  let(:message) { Faker::Lorem.paragraph }
  let(:support_email) { "ilgamgaysin@gmail.com" }
  let(:subject) { "Письмо в техподдержку!" }

  describe "#notification" do
    let(:mail) { ContactMailer.notification(name, sender_email, message) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([support_email])
      expect(mail.from).to eq([support_email])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(sender_email)
      expect(mail.html_part.decoded).to match(name)
      expect(mail.html_part.decoded).to match(message)
    end
  end
end

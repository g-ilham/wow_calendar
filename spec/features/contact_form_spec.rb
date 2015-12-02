require "rails_helper"

describe "Contact form", %q{
As a user of the website
I want to have ability to send Contact message to support
so that I can leave some feedbacks or suggestions about service
}, js: true do

  let(:name) { "Test Name" }
  let(:email) { generate :email }
  let(:message) { "Test Message" }

  before do
    visit root_path
  end

  it "I mistakenly submit contact form without data" do
    expect do
      within("#js-contact-form") do
        click_button "Отправить"

        wait_for_ajax
      end
    end.to_not change(Sidekiq::Extensions::DelayedMailer.jobs, :size)

    expect_to_see I18n.t(:errors)[:messages][:empty]
    expect_to_see_no "Ваше сообщение успешно отправлено!"
  end

  it "I mistakenly submit contact form with incorrect email" do
    expect do
      within("#js-contact-form") do
        fill_in "Email", with: "foobar"
        click_button "Отправить"

        wait_for_ajax
      end
    end.to_not change(Sidekiq::Extensions::DelayedMailer.jobs, :size)

    expect_to_see I18n.t(:errors)[:messages][:invalid]
    expect_to_see_no "Ваше сообщение успешно отправлено!"
  end

  it "I submit contact form with correct data" do
    expect do
      within("#js-contact-form") do
        fill_contact_form_properly
        click_button "Отправить"

        wait_for_ajax
      end
    end.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)

    expect_to_see "Ваше сообщение успешно отправлено!"
  end

  private

  def fill_contact_form_properly
    fill_in "Имя", with: name
    fill_in "Email", with: email
    fill_in "Сообщение", with: message
  end
end

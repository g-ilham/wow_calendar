require "rails_helper"

describe "Events form", %q{
As a user of the website
I want to have ability to remove event
}, js: true do

  let(:event) { FactoryGirl.create(:event) }

  before do
    login_as(event.user, scope: :user)
    page.driver.browser.timeout = 10

    visit users_events_path
  end

  it "I submit remove request for destroy event" do
    expect(Event.count).to eq 1

    show_modal

    within("#event_form_modal") do
      click_on "Удалить"
    end

    sleep 4 # waiting for AJAX response

    expect_to_see_no title
    expect(Event.count).to eq 0
  end

  def show_modal
    remove_animation_modal
    find(:xpath, "//div[@data-event-id='#{event.id}']").click
  end
end

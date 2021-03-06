require "rails_helper"

describe "Events form", %q{
As a user of the website
I want to have ability to remove event
}, js: true, skip_travis: true do

  let(:event) { FactoryGirl.create(:event) }

  before do
    login_as(event.user, scope: :user)
    visit users_events_path
    show_modal
  end

  it "I submit remove request for destroy event" do
    expect do
      within("#event_form_modal") do
        click_on "Удалить"
        wait_for_ajax
      end
    end.to change(Event, :count).from(1).to(0)

    expect_to_see_no title
  end

  def show_modal
    remove_animation
    find(:xpath, "//div[@data-event-id='#{event.id}']").click
  end
end

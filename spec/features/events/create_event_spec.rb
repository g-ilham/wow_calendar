require "rails_helper"

describe "Events form", %q{
As a user of the website
I want to have ability to create event
}, js: true do

  let(:user) { FactoryGirl.create(:user) }
  let(:title) { "Тренировка" }

  before do
    login_as(user, scope: :user)
    visit events_path
    show_modal
  end

  it "I'll see the correct start and end date" do
    to_eq_in_selector(js_value('#event_starts_at'),
                              "#{event_date_parsed(Time.zone.now)}")
    to_eq_in_selector(js_value('#event_ends_at'),
                              "#{event_date_parsed(Time.zone.now + 10.minute)}")
  end

  it "I mistakenly submit event form with incorrect title" do
    expect do
      within("#event_form_modal") do
        fill_in "event_title", with: ""
        click_on "Создать"
        wait_for_ajax
      end
    end.to change(Event, :count).by(0)

    expect_to_see I18n.t("errors.messages.too_short.few", count: 2)
    expect_to_see "Создание события"
  end

  it "I submit event form with correct data" do
    expect do
      within("#event_form_modal") do
        fill_in "event_title", with: title
        click_on "Создать"
        wait_for_ajax
      end
    end.to change(Event, :count).by(1)

    expect_to_see_no I18n.t("errors.messages.too_short.few", count: 2)
    expect_to_see_no "Создание события"
    expect_to_see title
  end

  def show_modal
    remove_animation_modal
    page.execute_script("$('.js-alt-create-event-link').trigger('click')")
  end
end

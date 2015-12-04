require "rails_helper"

describe "Events form", %q{
As a user of the website
I want to have ability to update event
}, js: true do

  let(:event) { FactoryGirl.create(:event) }
  let(:title) { "Тренировка" }
  let(:starts_at) { event.starts_at + 1.hour }
  let(:invalid_datetime_message) { translated_attr("starts_at") + invalid_date_message }
  let(:reloaded_starts_at) { parse_db_datetime(event.reload.starts_at) }

  before do
    login_as(event.user, scope: :user)
    visit events_path
    show_modal
  end

  it "I'm going to see the details of your event" do
    expect_to_see_in_selector("#event_title[value='#{event.title}']")
    to_eq_in_selector(js_value('#event_starts_at'),
                              "#{event_date_parsed(event.starts_at)}")
    to_eq_in_selector(js_value('#event_ends_at'),
                              "#{event_date_parsed(event.ends_at)}")
    expect_to_see "Редактирование события"
  end

  it "I mistakenly submit event form with incorrect title" do
    within("#event_form_modal") do
      fill_form_attrs("", "")
      click_on "Обновить"
      # wait_for_ajax
      sleep 3
    end

    expect_to_see I18n.t("errors.messages.too_short.few", count: 2)
    expect_to_see invalid_datetime_message
  end

  it "I submit event form with correct data" do
    within("#event_form_modal") do
      fill_form_attrs(title, event_date_parsed(starts_at))
      click_on "Обновить"
      # wait_for_ajax
      sleep 3
    end

    expect_to_see title
    expect(event.reload.title).to eql(title)
    expect(reloaded_starts_at).to eq(parse_db_datetime(starts_at))

    expect_to_see_no I18n.t("errors.messages.too_short.few", count: 2)
    expect_to_see_no invalid_datetime_message
    expect_to_see_no "Редактирование события"
  end

  def show_modal
    remove_animation_modal
    find(:xpath, "//div[@data-event-id='#{event.id}']").click
  end

  def translated_attr(column)
    Event.human_attribute_name(column) + ' '
  end

  def invalid_date_message
    I18n.t(:errors)[:messages][:invalid_datetime]
  end

  def fill_form_attrs(title, starts_at)
    fill_in "event_title", with: title
    fill_in "event_starts_at", with: starts_at
  end

  def parse_db_datetime(datetime)
    datetime.strftime('%Y-%m-%d %H:%M%')
  end
end

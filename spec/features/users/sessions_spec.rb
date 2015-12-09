require "rails_helper"

describe "User registrations form", %q{
As a user of the website
I want to have ability to authenticate on website
that I can submit my email and password
}, js: true do

  let(:user) { FactoryGirl.create(:user) }

  before do
    visit root_path
    remove_animation
    show_modal
  end

  it "I'm going to see login message" do
    expect_to_see "Вход"
  end

  it "I mistakenly submit login form with incorrect email" do
    within(".modal-body") do
      fill_in "user_email", with: "foobar"
      click_on "Войти"
      wait_for_ajax
    end

    expect_to_see I18n.t(:errors)[:messages][:invalid]
    expect_to_see "Вход"
  end

  it "I submit login form with correct data" do
    within(".modal-body") do
      fill_settings_form_properly
      click_button "Войти"
      sleep 3
    end

    expect_to_see_no I18n.t(:errors)[:messages][:invalid]
    expect_to_see_no "Вход"
    expect_to_see "Выйти"
  end

  def fill_settings_form_properly
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
  end

  def translated_attr(column)
    User.human_attribute_name(column) + ' '
  end

  def show_modal
    within "#nav" do
      click_link "Войти"
    end
    wait_for_ajax
    page.execute_script("$('.modal-backdrop').hide()")
  end
end

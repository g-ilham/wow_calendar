require "rails_helper"

describe "User registrations form", %q{
As a user of the website
I want to have ability to create account
that I can submit my email and another data
}, js: true do

  let(:email) { generate :email }
  let(:password) { "12345678" }
  let(:password_confirmation) { password }

  before do
    visit root_path
    remove_animation
    show_modal
  end

  it "I'm going to see registration message" do
    expect_to_see "Регистрация"
  end

  it "I mistakenly submit registration form with empty form" do
    expect do
      within("#new_user") do
        click_on "Зарегистрироваться"
        wait_for_ajax
      end
    end.to_not change(User, :count)

    expect_to_see I18n.t(:errors)[:messages][:empty]
    expect_to_see "Регистрация"
  end

  it "I mistakenly submit registration form with incorrect email" do
    expect do
      within("#new_user") do
        fill_in "user_email", with: "foobar"
        click_on "Зарегистрироваться"
        wait_for_ajax
      end
    end.to_not change(User, :count)

    expect_to_see I18n.t(:errors)[:messages][:invalid]
    expect_to_see I18n.t(:errors)[:messages][:empty]
    expect_to_see "Регистрация"
  end

  it "I submit registration form with correct data" do
    expect do
      within("#new_user") do
        allow_any_instance_of(User).to receive(:confirmed?).and_return(true)
        fill_settings_form_properly
        click_button "Зарегистрироваться"
        wait_for_ajax
      end
    end.to change(User, :count).by(1)

    expect_to_see_no I18n.t(:errors)[:messages][:invalid]
    expect_to_see_no I18n.t(:errors)[:messages][:empty]
    expect_to_see_no "Регистрация"
  end

  def fill_settings_form_properly
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password_confirmation
    page.execute_script("$('#user_in_fifteen_minutes').trigger('click')")
  end

  def show_modal
    within "#banner" do
      click_link "Зарегистрироваться"
    end
    wait_for_ajax
    page.execute_script("$('.modal-backdrop').hide()")
  end
end

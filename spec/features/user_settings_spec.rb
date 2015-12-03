require "rails_helper"

describe "User settings form", %q{
As a user of the website
I want to have ability to update my profile
that I can update user data
}, js: true do

  let(:user) { FactoryGirl.create(:user) }
  let(:email) { generate :email }
  let(:first_name) { "Igor" }

  before do
    login_as(user, scope: :user)
    visit root_path
    remove_animation_modal
    show_modal
  end

  it "I'm going to see your data" do
    expect_to_see_in_selector("#user_email[value='#{user.email}']")
    expect_to_see_in_selector("#user_first_name[value='#{user.first_name}']")
  end

  it "I mistakenly submit settings form with incorrect email" do
    within("#edit_user_settings") do
      fill_in "Email", with: "foobar"
      click_on "Обновить"
      wait_for_ajax
    end

    expect_to_see I18n.t(:errors)[:messages][:invalid]
    expect_to_see_no I18n.t(:devise)[:registrations][:updated]
  end

  it "I submit settings form with correct data" do
    within("#edit_user_settings") do
      fill_settings_form_properly
      click_button "Обновить"
      wait_for_ajax
    end

    expect(user.reload.first_name).to eql(first_name)
    expect(user.reload.in_fifteen_minutes).to be_truthy

    expect_to_see_no I18n.t(:errors)[:messages][:invalid]
    expect_to_see I18n.t(:devise)[:registrations][:updated]
  end

  def fill_settings_form_properly
    fill_in "First Name", with: first_name
    page.execute_script("$('#user_in_fifteen_minutes').trigger('click')")
  end

  def show_modal
    click_link "Настройки"
    wait_for_ajax
    page.execute_script("$('.modal-backdrop').hide()")
  end
end

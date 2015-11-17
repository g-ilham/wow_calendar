class HomeController < ApplicationController
  layout :resolve_layout
  skip_before_filter :complete_registration!
  before_action :set_email, only: [ :complete_social_registration_form, :add_email_for_social ]

  expose(:skel_css_files) do
    System::SkelCssFilesUrls.new().paths
  end

  expose(:set_email) do
    current_user.email = params['user']['email'] if  params['user']['email']
  end

  def index
  end

  def complete_social_registration_form
  end

  def add_email_for_social
    puts "user email #{current_user.email}"
    puts "user valid #{current_user.valid?}"
    if current_user.valid?
      current_user.skip_confirmation!
      current_user.save!
    end
  end

  private

  def resolve_layout
    case action_name
    when 'index'
      'landing'
    else
      'devise'
    end
  end
end

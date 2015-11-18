class HomeController < ApplicationController
  layout :resolve_layout
  skip_before_filter :complete_registration!
  skip_before_filter :authenticate_user!, only: [ :index ]
  before_action :set_email, only: [ :complete_social_registration_form, :add_email_for_social ]

  expose(:skel_css_files) do
    System::SkelCssFilesUrls.new().paths
  end

  expose(:email_params) do
    if params['user'] && params['user']['email']
      params['user']['email']
    end
  end

  expose(:set_email) do
    current_user.email = email_params if email_params
  end

  def index
  end

  def complete_social_registration_form
  end

  def add_email_for_social
    if current_user.valid?
      current_user.update_column(:email,  email_params)
      current_user.skip_confirmation!; current_user.save!
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

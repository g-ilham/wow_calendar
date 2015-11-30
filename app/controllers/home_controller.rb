class HomeController < ApplicationController
  layout :resolve_layout

  before_action :set_email, except: [ :index ]
  before_action :not_completed_registration, except: [ :index ]
  skip_before_filter :social_registration!, except: [ :index ]
  skip_before_filter :authenticate_user!, only: [ :index ]

  expose(:skel_css_files) do
    System::SkelCssFilesUrls.new().paths
  end

  expose(:email_params) do
    if params['user'] && params['user']['email']
      params['user']['email']
    end
  end

  expose(:completed_registration?) do
    current_user.email.present?
  end

  expose(:set_email) do
    completed_registration?
    current_user.email = email_params if email_params
  end

  expose(:contact_form) do
    ContactForm.new({})
  end

  def index
  end

  def complete_social_registration
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

  def not_completed_registration
    if completed_registration?
      redirect_to root_url
    end
  end
end

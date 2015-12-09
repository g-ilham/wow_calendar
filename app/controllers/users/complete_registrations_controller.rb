class Users::CompleteRegistrationsController < ApplicationController
  layout 'devise'

  before_action :set_email
  before_action :not_completed_registration
  skip_before_action :social_registration!

  expose(:email_params) do
    if params['user'] && params['user']['email']
      params['user']['email']
    end
  end

  expose(:set_email) do
    completed_registration?
    current_user.email = email_params if email_params
  end

  def index
  end

  def update
    if current_user.valid?
      current_user.update_column(:email,  email_params)
      current_user.skip_confirmation!; current_user.save!
    end
  end

  private

  def not_completed_registration
    if completed_registration?
      redirect_to root_url
    end
  end
end

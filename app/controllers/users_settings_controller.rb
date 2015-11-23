class UsersSettingsController < ApplicationController
  respond_to :json

  def edit
  end

  def update
    current_user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email,
                                :first_name,
                                :last_name,
                                :photo,
                                :in_fifteen_minutes,
                                :in_hour,
                                :in_day)
  end
end

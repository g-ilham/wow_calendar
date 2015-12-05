class Users::SettingsController < ApplicationController
  respond_to :json

  expose(:notifications_generator) do
    Users::Notifications.new(current_user, @prev_notifications_options)
  end

  def update
    @prev_notifications_options = current_user.notifications_options

    if current_user.update(user_params)
      notifications_generator.run
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :photo,
      :in_fifteen_minutes,
      :in_hour,
      :in_day
    )
  end
end

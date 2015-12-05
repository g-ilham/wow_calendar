class Users::SettingsController < ApplicationController
  respond_to :json
  before_action :get_prev_notifications_options, only: [ :update ]

  expose(:check_changed_notifications_options) do
    Events::Notifications.new(nil).
      update_events_notifications!(current_user, @prev_notifications_options)
  end

  def edit
  end

  def update
    current_user.update(user_params)
    check_changed_notifications_options
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

  def get_prev_notifications_options
    @prev_notifications_options = current_user.notifications_options
  end
end

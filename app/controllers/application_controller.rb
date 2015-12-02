class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :social_registration!
  before_action :authenticate_user!

  expose(:gritter_image_url) do
    System::GetAssetFilesUrls.get_image_url('theme/ui-sam.jpg')
  end

  expose(:events) do
    serialize_events(current_user.events)
  end

  expose(:event) do
    current_user.events.find_by_id(params[:id])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
  end

  def social_registration!
    if current_user && current_user.email.blank?
      redirect_to complete_social_registration_path
    end
  end

  def serialize_events(current_event_or_events)
    ActiveModel::ArraySerializer.new(
      [current_event_or_events].flatten,
      each_serializer: EventSerializer
    )
  end
end

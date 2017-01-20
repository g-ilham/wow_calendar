class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :social_registration!
  before_action :authenticate_user!

  expose(:gritter_image_url) do
    System::GetAssetFilesUrls.get_image_url('theme/ui-sam.jpg')
  end

  expose(:skel_css_files) do
    System::SkelCssFilesUrls.new().paths
  end

  expose(:completed_registration?) do
    current_user.email.present?
  end

  protected

  def social_registration!
    if current_user && current_user.email.blank?
      redirect_to users_complete_registrations_path
    end
  end
end

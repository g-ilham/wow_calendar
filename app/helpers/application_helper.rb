module ApplicationHelper
  def active_account?
    user_signed_in? && completed_registration?
  end
end

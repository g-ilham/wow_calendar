class HomeController < ApplicationController
  layout 'landing'
  skip_before_action :authenticate_user!

  expose(:contact_form) do
    ContactForm.new({})
  end

  def index
  end
end

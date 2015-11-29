class ContactsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_filter :complete_registration!

  expose(:contact_form) do
    ContactForm.new contact_form_params
  end

  def create
    contact_form.run!
  end

  private

  def contact_form_params
    params[:contact_form]
  end
end

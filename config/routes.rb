Rails.application.routes.draw do
  get 'home/index'
  get 'complete_social_registration_form', to: 'home#complete_social_registration_form'
  put 'add_email_for_social', to: 'home#add_email_for_social'

  devise_for :users
  root to: 'home#index'
  resources :users_settings, only: [ :edit, :update ]

  ##########################
  #         Themes         #
  ##########################
  resources :themes, only: :index do
    collection do
      %w(blank general buttons panels calendar gallery todos login basic_tables responsive_tables form_components).each do |action_name|
        get action_name
      end
    end
  end
end

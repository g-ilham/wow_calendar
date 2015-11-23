require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  root to: 'home#index'

  get 'home/index'
  get 'complete_social_registration_form', to: 'home#complete_social_registration_form'
  put 'add_email_for_social', to: 'home#add_email_for_social'

  devise_for :users
  resources :users_settings, only: [ :edit, :update ]
  resources :events, except: [ :new, :edit ]

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

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  devise_for :users,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks",
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  namespace :users do
    resources :settings, only: [ :edit, :update ]
    resources :events, except: [ :new, :edit ]
  end

  resources :contacts, only: [ :create ]

  get 'complete_social_registration', to: 'home#complete_social_registration'
  put 'add_email_for_social', to: 'home#add_email_for_social'

  get 'home/index'
  root to: 'home#index'

  ##########################
  #         Themes         #
  ##########################
  resources :themes, only: :index do
    collection do
      %w(blank general buttons panels calendar gallery task_lists login basic_tables responsive_tables form_components).each do |action_name|
        get action_name
      end
    end
  end
end

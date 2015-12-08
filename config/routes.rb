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
    resources :complete_registrations, only: [ :index, :update ]
  end

  resources :contacts, only: [ :create ]

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

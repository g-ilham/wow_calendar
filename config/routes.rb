Rails.application.routes.draw do
  get 'home/index'

  devise_for :users
  root 'home#index'
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

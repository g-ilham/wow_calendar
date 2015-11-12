Rails.application.routes.draw do
  root 'themes#index'
  resources :themes, only: :index do
    collection do
      %w(blank general buttons panels calendar gallery todos login basic_tables responsive_tables).each do |action_name|
        get action_name
      end
    end
  end
end

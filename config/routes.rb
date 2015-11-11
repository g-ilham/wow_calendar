Rails.application.routes.draw do
  root 'themes#dashboard'
  get 'blank', to: 'themes#blank'
end

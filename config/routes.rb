Rails.application.routes.draw do

  devise_for :users

  root 'users#my_account'

  resources :events
  resources :bills

  get '/my_account', action: :my_account, controller: :users

end

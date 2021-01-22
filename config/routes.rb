Rails.application.routes.draw do
  
  get 'home/index'
  devise_for :users
  get 'auth/:provider/callback', to: 'home#fetch_email'
  root to: 'emails#index'
  resources :contacts do
  	collection do 
  		post :extract_multiple_mails
  	end
  end

  resources :emails, only: [:index, :show, :destroy]


  get 'auth/:provider/callback', to: 'sessions#create'
  get '/fetch_email', to: 'home#fetch_email'
  get '/user_mails', to: 'home#mails'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

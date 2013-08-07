Hudacard::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # Root path creates a new game (and *renders* edit to play it)
  root :to => 'games#new'
  
  devise_for :users

  resources :users, :only => [:show] do
    member do
      get 'balance_inquiry'
      get 'qrcode'
      post 'withdrawal'
    end
  end
  
  # Path with token plays the current game ("edits" the game)
  # Placing a bet "updates" the game
  # A game consists of a single bet, so after one update the system shows the result
  resources :games, :only => [:edit, :update, :show] do
    get 'error', :on => :collection
  end
  
  resources :btc_transactions, :only => [:index, :update]
end

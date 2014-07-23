Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  #get '/', to: 'videos#index'can not direct to same controller ??
  resources :videos do
    resources :reviews, only: [:create, :update]
  end
  namespace :admin do
    resources :videos, only: [:new, :create]
  end
  get '/search', to: 'videos#search'
  #get '/', to: 'front#index'
  resources :users, only: [:new, :create, :edit, :update, :show]
  get '/new_user_via_invitation', to: 'users#new_user_via_invitation'

  resources :sessions, only: [:new, :create, :destroy]
  root to: 'front#index'
  
  get '/logout', to: 'sessions#destroy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  resources :queues, only:[:create, :destroy] do
    collection do
      post 'update_instant'
    end
  end
  get '/my_queue', to: 'queues#index' 

  resources :categories, only: [:show]

  resources :follow_relationships, only: [:show, :destroy, :create]
  get '/people', to: 'follow_relationships#show'

  resources :pw_resets, only: [:show, :create, :new]
  get '/forgot_pw', to: 'pw_resets#new'
  get '/enter_email', to: 'pw_resets#enter_email'
  get '/reset_pw', to: 'pw_resets#reset_pw'

  resources :invite_users
  get '/send_invite_email', to: 'invite_users#new'

  namespace :admin do
      resources :views_payments, only: [:index]
  end

  mount StripeEvent::Engine => '/stripe' # provide a custom path

  resources :plan_and_billings, only: [:index]

  get '/cancel_subscription', to: 'plan_and_billings#cancel_subscription'
  get '/reactive_subscription', to: 'plan_and_billings#reactive_subscription'
end

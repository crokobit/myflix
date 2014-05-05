Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  resources :videos do
    resources :reviews, only: [:create, :update]
  end
  get '/search', to: 'videos#search'
  #get '/', to: 'front#index'
  resources :users, only: [:new, :create, :edit, :update, :show]
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

end

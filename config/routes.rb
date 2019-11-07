Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  get '/edit-basic-info/:id', to: 'users#edit_basic_info', as: :basic_info
  
  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :bases
  resources :users do
    collection { post :import }
    collection { get :on_duty }
    member do
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update 
  end
end

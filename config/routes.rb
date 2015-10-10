BookIT::Application.routes.draw do


  resources :party_reports, only: :index do
    member do
      get :reply
      post :send_reply
      get :accept
      get :reject
      get :mark_as_sent
    end
  end

  resource :party_reports, only: [] do
    member do
      get :preview_bookings
      post :send_bookings
    end
  end

  resources :bookings do
    collection do
      get :calendar_data
    end
  end

  resources :rules, :rooms
  resources :terms, only: [:index, :edit, :update]
  
  get 'current' => 'bookings#current'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'bookings#index'
end

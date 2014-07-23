BookIT::Application.routes.draw do


  resources :party_reports, only: :index do
    member do
      get :reply
      post :send_reply
    end
  end

  resource :party_reports, only: [] do
    member do
      get :preview_bookings
      post :send_bookings
    end
  end

  resources :bookings do
    member do
      get :accept
      get :reject
    end
  end

  resources :rules, :rooms
  resources :terms, only: [:index, :edit, :update]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'bookings#index'
end

BookIT::Application.routes.draw do

  resources :whitelist_items, :bookings, :rooms
  resources :terms, only: [:index, :edit, :update]

  get '/export/:room_id.ics' => 'export#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'bookings#index'
end

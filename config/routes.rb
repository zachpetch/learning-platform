Rails.application.routes.draw do
  resources :schools, only: [ :show ]
  resources :users, only: [ :show ]
  root "dashboard#index"
  # get "/", to: "dashboard#index"

  resources :dashboard, only: [ :index ] do
    collection do
      get :search_schools_ajax
      get :search_terms_ajax
      get :search_courses_ajax
      get :search_students_ajax
    end
  end

  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end

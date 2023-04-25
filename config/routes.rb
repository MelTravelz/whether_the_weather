Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get "/forecast", to: "forecast#index"

      post "/users", to: "users#create"

      # unRESTful route:
      post "/sessions", to: "users#login"
    end
  end
end

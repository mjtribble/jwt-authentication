Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  # token controller with validate and refresh actions
  namespace :api do
    namespace :v1 do
      post "users/register", to: "users#register"
      post "users/login", to: "users#login"
      post "tokens/validate", to: "tokens#validate"
      post "tokens/refresh", to: "tokens#refresh"
      get "widgets/index", to: "widgets#index"
    end
  end
end

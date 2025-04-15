Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"

  get "/me", to: "users#me"
  get '/assignment_insights', to: 'assignment_insights#index'

  get '/teams', to: 'teams#index'
  get "/team_assignments/find_by_pair", to: 'team_assignments#find_by_pair'
  get '/leader_team_insights', to: 'leader_team_insights#index'
  resources :team_assignments, only: [:create, :destroy]
  resources :pies_entries, only: [ :create, :index ]
  resources :unmatched_keywords, only: [ :index ]
  resources :reflection_tips, only: [ :index, :create, :update, :destroy ]
end

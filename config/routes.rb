Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"
  
  get '/memberships/me', to: 'memberships#me'
  get "/me", to: "users#me"
  get "/assignment_insights", to: "assignment_insights#index"

  get "/teams", to: "teams#index"
  get "/team_assignments/find_by_pair", to: "team_assignments#find_by_pair"
  get "/leader_team_insights", to: "leader_team_insights#index"

  post   "/password_resets",      to: "password_resets#create" # email submit
  get    "/password_resets/edit", to: "password_resets#edit"   # verify token
  patch  "/password_resets",      to: "password_resets#update" # set new password

  get "/reflection_tips/pies_tip_map", to: "reflection_tips#pies_tip_map"
  get '/events/:id/host_check', to: 'events#host_check'
  
  post '/memberships/invite', to: 'memberships#invite'
  
  resources :memberships, only: [ :update, :index ]
  resources :team_assignments, only: [ :create, :destroy ]
  resources :pies_entries, only: [ :create, :index ]
  resources :unmatched_keywords, only: [ :index, :destroy ]
  resources :reflection_tips, only: [ :index, :create, :update, :destroy ]
  resources :dismissed_keywords, only: [ :create ]
  resources :events, only: [ :index, :create, :update, :show ]
end

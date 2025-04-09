Rails.application.routes.draw do
  resources :search_queries, only: [:create, :index]
  get 'analytics', to: 'search_queries#analytics'
  root 'search_queries#index'  # Set the root to the index action
end

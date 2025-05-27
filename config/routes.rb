Rails.application.routes.draw do
  root 'date_ideas#index'

  # Authentication
  get '/sign_up', to: 'users#new'
  post '/users', to: 'users#create'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'

  # Date Ideas
  get  'date_ideas/generate', to: 'date_ideas#generate' # ← Added GET version (must come before :id)
  post 'date_ideas/generate', to: 'date_ideas#generate'
  post 'date_ideas/save_generated_date', to: 'date_ideas#save_generated_date'
  get  'date_ideas/:id', to: 'date_ideas#show', as: 'date_idea' # ← This must stay last to avoid conflicts

  # Saved Dates
  resources :saved_dates, only: [:index, :show, :create, :destroy] do
    member do
      patch :toggle_favorite
      patch :mark_completed
    end
  end

  resources :users, only: [:show]
end

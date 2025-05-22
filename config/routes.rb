Rails.application.routes.draw do
  root 'date_ideas#index'
  
  # Explicit routes for date_ideas actions to avoid conflicts
  get 'date_ideas', to: 'date_ideas#index'
  post 'date_ideas/generate', to: 'date_ideas#generate'
  post 'date_ideas/save_generated_date', to: 'date_ideas#save_generated_date'
  get 'date_ideas/:id', to: 'date_ideas#show', as: 'date_idea'
  
  resources :saved_dates, only: [:index, :show, :create, :destroy] do
    member do
      patch :toggle_favorite
      patch :mark_completed
    end
  end
  
  resources :users, only: [:show, :new, :create]
end

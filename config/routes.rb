Rails.application.routes.draw do
  root 'date_ideas#index'
  
  resources :date_ideas do
    collection do
      post :generate  # This will handle the form submission
    end
  end
  
  resources :saved_dates, only: [:index, :show, :create, :destroy] do
    member do
      patch :toggle_favorite
      patch :mark_completed
    end
  end
  
  resources :users, only: [:show, :new, :create]
end

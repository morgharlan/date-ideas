Rails.application.routes.draw do

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
root 'date_ideas#index'
  
  resources :users do
    resources :saved_dates, only: [:index, :create, :update, :destroy]
  end
  
  resources :date_ideas do
    member do
      post :save_date
    end
  end
  
  resources :saved_dates, only: [:show, :update, :destroy]
end

class SavedDatesController < ApplicationController
  before_action :set_saved_date, only: [:show, :toggle_favorite, :mark_completed, :destroy]

  def index
    # For now, get all saved dates (later we'll filter by current user)
    @saved_dates = SavedDate.includes(:date_idea)
    
    # Apply filters
    case params[:filter]
    when 'favorites'
      @saved_dates = @saved_dates.where(favorite: true)
    when 'completed'
      @saved_dates = @saved_dates.where(completed: true)
    when 'planned'
      @saved_dates = @saved_dates.where(completed: false)
    end
    
    @saved_dates = @saved_dates.order(created_at: :desc)
  end

  def show
    # Individual saved date view
  end

  def toggle_favorite
    @saved_date.update(favorite: !@saved_date.favorite)
    redirect_back(fallback_location: saved_dates_path)
  end

  def mark_completed
    @saved_date.update(completed: !@saved_date.completed)
    redirect_back(fallback_location: saved_dates_path)
  end

  def destroy
    @saved_date.destroy
    redirect_to saved_dates_path, notice: 'Date removed from your saved list.'
  end

  private

  def set_saved_date
    @saved_date = SavedDate.find(params[:id])
  end
end

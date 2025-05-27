class SavedDatesController < ApplicationController
  before_action :require_login
  before_action :set_saved_date, only: [:show, :toggle_favorite, :mark_completed, :destroy]
  before_action :authorize_saved_date, only: [:show, :toggle_favorite, :mark_completed, :destroy]

  def index
    @saved_dates = current_user.saved_dates.includes(:date_idea)

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

  def create
  puts "🔍 Params received: #{params.inspect}"
  puts "👤 Current user: #{current_user&.id}"

  # Create a new DateIdea record from form data
  idea = DateIdea.new(
    title:         params[:title],
    description:   params[:description],
    budget:        params[:budget],
    time_of_day:   params[:time_of_day],
    setting:       params[:setting],
    effort:        params[:effort],
    city:          params[:location] # assuming this maps to `city` in your model
  )

  if idea.save
    saved_date = current_user.saved_dates.build(date_idea: idea)

    if saved_date.save
      puts "✅ SavedDate and DateIdea created!"
      redirect_to saved_dates_path, notice: "Date saved!"
    else
      puts "❌ Failed to save SavedDate: #{saved_date.errors.full_messages}"
      redirect_to root_path, alert: "Failed to save date."
    end
  else
    puts "❌ Failed to save DateIdea: #{idea.errors.full_messages}"
    redirect_to root_path, alert: "Failed to save date idea."
  end
end

  def show
    # Already set by before_action
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

  def authorize_saved_date
    unless @saved_date.user == current_user
      redirect_to saved_dates_path, alert: "You're not authorized to view that date."
    end
  end

  def require_login
    unless current_user
      redirect_to sign_in_path, alert: "Please sign in to view your saved dates."
    end
  end
end

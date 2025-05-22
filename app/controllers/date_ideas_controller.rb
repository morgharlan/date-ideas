class DateIdeasController < ApplicationController
  def index
    @date_ideas = DateIdea.all
  end

  def show
    @date_idea = DateIdea.find(params[:id])
  end
end

class StoriesController < ActionController::Base

  def index
    render json: StoriesSerializer.new(Story.all)
  end

  def show
    render json: DetailedStorySerializer.new(Story.find(params[:id]))
  end

end

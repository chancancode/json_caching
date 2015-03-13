class StoriesController < ActionController::Base

  before_action :force_expiration!

  def index
    render json: StoriesSerializer.new(Story.order(:id)).to_json
  end

  def show
    render json: DetailedStorySerializer.new(Story.find(params[:id])).to_json
  end

  private

    def force_expiration!
      if params[:expire_all]
        AsJsonEncoder.cache.clear
      end

      if params[:expire_story]
        Story.find(params[:expire_story]).touch
      end

      if params[:expire_article]
        Article.find(params[:expire_article]).touch
      end

      if params[:expire_comment]
        Comment.find(params[:expire_comment]).touch
      end
    end

end

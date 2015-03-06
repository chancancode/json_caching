class DetailedStorySerializer < Struct.new(:story)

  include ActiveSupport::JSON::Encoding::Cachable

  def article
    defined?(@article) ? @article : @article = Article.find_by_url(story.url)
  end

  def cache_key
    if article
      'detailed/' + story.cache_key + article.cache_key
    else
      'detailed/' + story.cache_key
    end
  end

  def as_json(*)
    {
      story: StorySerializer.new(story),
      article: article ? ArticleSerializer.new(article) : nil,
      comments: story.comments.map { |comment| CommentSerializer.new(comment) }
    }
  end

end
class ArticleSerializer < Struct.new(:article)

  include ActiveSupport::JSON::Encoding::Cachable

  delegate :cache_key, to: :article

  def as_json(*)
    article.as_json(
      only: [
        :id,
        :url,
        :title,
        :author,
        :body
      ]
    )
  end

end
class StorySerializer < Struct.new(:story)

  include ActiveSupport::JSON::Encoding::Cachable

  delegate :cache_key, to: :story

  def as_json(*)
    story.as_json(
      only: [
        :id,
        :tag,
        :title,
        :url,
        :source,
        :body,
        :points,
        :submitted,
        :submitter,
        :comments_count
      ]
    )
  end

end
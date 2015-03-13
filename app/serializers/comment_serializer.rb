class CommentSerializer < Struct.new(:comment)

  include Cachable

  delegate :cache_key, to: :comment

  def as_json(*)
    comment.as_json(
      only: [
        :id,
        :is_dead,
        :body,
        :quality,
        :submitter,
        :submitted,
        :parent_id,
        :story_id
      ]
    )
  end

end
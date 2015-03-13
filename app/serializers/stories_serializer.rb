class StoriesSerializer < Struct.new(:stories)

  include Cachable

  def cache_key
    'stories/' + stories.max_by(&:updated_at).cache_key
  end

  def as_json(*)
    { stories: stories.map { |story| StorySerializer.new(story) } }
  end

end
require 'json'

def read_json(filename)
  JSON.parse File.read(File.expand_path("../#{filename}", __FILE__))
end

Story.delete_all

Story.create! read_json('stories.json')

Article.delete_all

Article.create! read_json('articles.json')

Comment.delete_all

Comment.create! read_json('comments.json')

# Something is wrong with the seed data, for some reaon not all comments has
# the story_id set properly

20.times do
  Comment.where(story_id: nil).where.not(parent_id: nil).each do |comment|
    comment.update!(story_id: comment.parent.story_id)
  end
end

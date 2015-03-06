class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :tag
      t.string :title
      t.string :url
      t.string :source
      t.text :body
      t.integer :points
      t.string :submitted
      t.string :submitter
      t.integer :comments_count

      t.timestamps null: false
    end
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.boolean :is_dead
      t.text :body
      t.float :quality
      t.string :submitter
      t.string :submitted
      t.references :parent, index: true
      t.references :story, index: true

      t.timestamps null: false
    end
    add_foreign_key :comments, :parents
    add_foreign_key :comments, :stories
  end
end

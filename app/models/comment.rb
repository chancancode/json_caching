class Comment < ActiveRecord::Base
  belongs_to :story, touch: true
  belongs_to :parent, class_name: Comment, touch: true
  has_many :children, class_name: Comment, inverse_of: :parent
end

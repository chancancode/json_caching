class Story < ActiveRecord::Base
  has_many :comments
end

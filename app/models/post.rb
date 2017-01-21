class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, foreign_key: :post_id
end

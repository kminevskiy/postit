class Post < ActiveRecord::Base
  PER_PAGE = 3

  include Voteable
  include Sluggable

  default_scope { order("created_at DESC") }

  belongs_to :creator, class_name: "User", foreign_key: :user_id
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 3 }, uniqueness: { case_sensitive: false }

  validates :url, presence: true
  validates :description, presence: true, uniqueness: true
end

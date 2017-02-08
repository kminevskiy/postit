class Post < ActiveRecord::Base
  belongs_to :creator, class_name: "User", foreign_key: :user_id
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  before_save :generate_slug

  validates :title, presence: true, length: {minimum: 3}, uniqueness: true
  validates :url, presence: true
  validates :description, presence: true, uniqueness: true

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug
    self.slug = self.title.parameterize
  end

  def to_param
    self.slug
  end
end

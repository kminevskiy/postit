class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  before_save :generate_slug

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def generate_slug
    self.slug = self.name.parameterize
  end

  def to_param
    self.slug
  end
end

module Sluggable
  extend ActiveSupport::Concern

  included do
    before_create :generate_slug
    before_update :reconstruct_slug
  end

  def generate_slug
    random_hex = SecureRandom.hex(8)
    self.slug = self.title.parameterize + "-#{random_hex}"
  end

  def reconstruct_slug
    self.slug = self.title.parameterize + "-#{self.slug.split("-").last}"
  end

  def to_param
    self.slug
  end
end

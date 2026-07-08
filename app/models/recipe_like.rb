class RecipeLike < ApplicationRecord
  belongs_to :recipe, counter_cache: :likes_count
  belongs_to :chef, optional: true

  validates :recipe_id, presence: true
  validates :chef_id, uniqueness: { scope: :recipe_id, allow_nil: true, message: "has already liked this recipe" }
  validates :visitor_token, uniqueness: { scope: :recipe_id, allow_nil: true, message: "has already liked this recipe" }

  before_validation :ensure_visitor_token

  private

  def ensure_visitor_token
    self.visitor_token = SecureRandom.uuid if chef_id.nil? && visitor_token.blank?
  end
end

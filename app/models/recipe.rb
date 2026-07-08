class Recipe < ApplicationRecord
  belongs_to :chef

  validates :title, :description, :category, presence: true
end

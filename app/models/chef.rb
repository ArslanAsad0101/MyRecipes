class Chef < ApplicationRecord
  has_secure_password

  has_many :recipes, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def conversations
    Conversation.where("chef_a_id = ? OR chef_b_id = ?", id, id).order(updated_at: :desc)
  end
end

class Conversation < ApplicationRecord
  belongs_to :chef_a, class_name: "Chef", foreign_key: :chef_a_id
  belongs_to :chef_b, class_name: "Chef", foreign_key: :chef_b_id
  has_many :messages, dependent: :destroy

  scope :for_chef, ->(chef) { where("chef_a_id = ? OR chef_b_id = ?", chef.id, chef.id) }

  validates :chef_a_id, :chef_b_id, presence: true

  # def self.find_or_create_between(chef_a, chef_b)
  #   first_id, second_id = [chef_a.id, chef_b.id].sort
  #   find_or_create_by!(chef_a_id: first_id, chef_b_id: second_id)
  # end

  def other_chef_for(chef)
    return chef_b if chef_a_id == chef.id

    chef_a
  end

  def includes_chef?(chef_id)
    [chef_a_id, chef_b_id].include?(chef_id)
  end

  def unread_count_for(chef)
    messages.where.not(chef_id: chef.id).where("created_at > ?", last_read_at_for(chef)).count
  end

  def mark_as_read_for(chef)
    Rails.cache.write("conversation_#{id}_read_at_#{chef.id}", Time.current)
  end

  def last_read_at_for(chef)
    Rails.cache.read("conversation_#{id}_read_at_#{chef.id}") || Time.at(0)
  end
end

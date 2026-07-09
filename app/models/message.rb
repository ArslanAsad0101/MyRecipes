class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :chef

  after_create_commit do
    ConversationChannel.broadcast_to(conversation, {
      id: id,
      body: body,
      sender_id: chef_id,
      sender_name: chef.name,
      created_at: created_at.strftime("%H:%M")
    })
  end
end

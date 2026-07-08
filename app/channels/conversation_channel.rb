class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])
    reject unless current_chef.present? && conversation.includes_chef?(current_chef.id)
    stream_for conversation
  end

  def unsubscribed
  end

  private

  def current_chef
    @current_chef ||= Chef.find_by(id: connection.current_chef_id)
  end
end

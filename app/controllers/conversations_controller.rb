class ConversationsController < ApplicationController
  before_action :require_chef!
  before_action :set_conversation, only: %i[show]

  def index
    @conversations = current_chef.conversations.includes(:messages).order(updated_at: :desc)
    @available_chefs = Chef.where.not(id: current_chef.id)

    if params[:query].present?
      query = "%#{params[:query]}%"
      @available_chefs = @available_chefs.where("name LIKE ? OR email LIKE ?", query, query)
    end

    @conversation = @conversations.first
    @message = Message.new
  end

  def create
    other_chef = Chef.find(params[:chef_id])

    # if other_chef.id == current_chef.id
    #   redirect_to chat_path, alert: "You cannot start a chat with yourself." and return
    # end

    conversation = Conversation.find_or_create_between(current_chef, other_chef)
    redirect_to conversation_path(conversation)
  # rescue ActiveRecord::RecordNotFound
  #   redirect_to chat_path, alert: "Chef not found."
  end

  def show
    @conversations = current_chef.conversations.includes(:messages).order(updated_at: :desc)
    @available_chefs = Chef.where.not(id: current_chef.id)
    @message = Message.new

    # unless @conversation.includes_chef?(current_chef.id)
    #   redirect_to chat_path, alert: "You are not allowed to access that conversation."
    # end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end
end

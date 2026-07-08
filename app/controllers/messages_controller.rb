class MessagesController < ApplicationController
  before_action :require_chef!

  def create
    conversation = Conversation.find(params[:conversation_id])

    unless conversation.includes_chef?(current_chef.id)
      respond_to do |format|
        format.json { render json: { error: "You are not allowed to access that conversation." }, status: :forbidden }
        format.html { redirect_to chat_path, alert: "You are not allowed to access that conversation." }
      end
      return
    end

    @message = conversation.messages.build(body: params.dig(:message, :body), chef: current_chef)

    if @message.save
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            message: {
              id: @message.id,
              body: @message.body,
              sender_id: @message.chef_id,
              sender_name: @message.chef.name,
              created_at: @message.created_at.strftime("%H:%M")
            }
          }, status: :ok
        end
        format.html do
          redirect_to conversation_path(conversation), notice: "Message sent."
        end
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, errors: @message.errors.full_messages }, status: :unprocessable_entity }
        format.html { redirect_to conversation_path(conversation), alert: "Message cannot be blank." }
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.json { render json: { error: "Conversation not found." }, status: :not_found }
      format.html { redirect_to chat_path, alert: "Conversation not found." }
    end
  end
end

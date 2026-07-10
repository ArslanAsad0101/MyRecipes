class MessagesController < ApplicationController
  before_action :require_chef!

  def create
    conversation = Conversation.find(params[:conversation_id])
    raise AccessDenied unless conversation.includes_chef?(current_chef.id)

    @message = conversation.messages.build(body: params.dig(:message, :body), chef: current_chef)

    respond_to do |format|
      if @message.save
        format.html { redirect_to conversation_path(conversation), notice: "Message sent." }
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
      else
        format.html { redirect_to conversation_path(conversation), alert: "Message cannot be blank." }
        format.json { render json: { success: false, errors: @message.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to chat_path, alert: "Conversation not found." }
      format.json { render json: { error: "Conversation not found." }, status: :not_found }
    end
  end
end

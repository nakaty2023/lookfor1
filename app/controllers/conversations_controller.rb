class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.where('sender_id = ? OR recipient_id = ?', current_user.id, current_user.id)
  end

  def create
    @conversation = Conversation.between(params[:sender_id], params[:recipient_id])
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end

class ConversationsController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :correct_user, only: :show

  def index
    @conversations = Conversation.where('sender_id = ? OR recipient_id = ?', current_user.id, current_user.id)
  end

  def show
    @recipient = User.find(@conversation.recipient_user_id(current_user.id))
    @message = Message.new
  end

  def create
    @conversation = Conversation.between(conversation_params[:sender_id], conversation_params[:recipient_id])
    redirect_to conversation_path(@conversation)
  end

  private

  def conversation_params
    params.require(:conversation).permit(:sender_id, :recipient_id)
  end

  def correct_user
    @conversation = Conversation.find(params[:id])
    return if [@conversation.sender_id, @conversation.recipient_id].include?(current_user.id)

    flash[:alert] = t('.failure')
    redirect_to root_path
  end
end

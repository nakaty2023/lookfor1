class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :show
  before_action :load_conversations, only: %i[index show]
  before_action :check_conversations, only: :index

  def index
    load_users_from_conversations
  end

  def show
    load_users_from_conversations
    @recipient = User.find(@conversation.recipient_user_id(current_user.id))
    @message = Message.new
    @messages = @conversation.messages.includes(:user)
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

  def check_conversations
    return unless @conversations.empty?

    redirect_to user_path(current_user), notice: 'DM送信履歴がありません'
  end

  def load_conversations
    @conversations = Conversation.where('sender_id = ? OR recipient_id = ?', current_user.id, current_user.id)
  end

  def load_users_from_conversations
    other_user_ids = @conversations.map { |conversation| conversation.recipient_user_id(current_user.id) }
    @users = User.where(id: other_user_ids).includes(image_attachment: :blob)
  end
end

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.new(message_params)
    @message.user = current_user
    if @message.save
      redirect_to conversation_path(@conversation)
    else
      load_users_from_conversations
      @recipient = User.find(@conversation.recipient_user_id(current_user.id))
      @messages = @conversation.messages.includes(:user)
      render 'conversations/show', status: :unprocessable_entity
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @conversation = @message.conversation
    @message.destroy
    flash[:notice] = t('.success')
    redirect_to conversation_path(@conversation), status: :see_other
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def load_users_from_conversations
    @conversations = Conversation.where('sender_id = ? OR recipient_id = ?', current_user.id, current_user.id)
    other_user_ids = @conversations.map { |conversation| conversation.recipient_user_id(current_user.id) }
    @users = User.where(id: other_user_ids).includes(image_attachment: :blob)
  end
end

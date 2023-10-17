class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.new(message_params)
    @message.user = current_user
    if @message.save
      redirect_to conversation_path(@conversation)
    else
      render :show
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
end

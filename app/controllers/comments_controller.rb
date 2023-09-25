class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:notice] = t('.success')
      redirect_to @comment.exchangepost
    else
      @exchangepost = Exchangepost.find(@comment.exchangepost_id)
      @user = @exchangepost.user
      @comments = @exchangepost.comments.includes(:user)
      render 'exchangeposts/show', status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @exchangepost = @comment.exchangepost
    @comment.destroy
    flash[:notice] = t('.success')
    redirect_to @exchangepost, status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :exchangepost_id)
  end
end

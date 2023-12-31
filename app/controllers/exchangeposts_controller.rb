class ExchangepostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy]
  before_action :correct_user, only: :destroy

  def index
    @exchangeposts = Exchangepost.all.includes({ user: { image_attachment: :blob } }, { images_attachments: :blob })
  end

  def search
    @q = Exchangepost.ransack(params[:q_exchangeposts])
    @exchangeposts = @q.result(distinct: true).includes({ user: { image_attachment: :blob } },
                                                        { images_attachments: :blob })
  end

  def show
    @exchangepost = Exchangepost.includes({ images_attachments: :blob }).find(params[:id])
    @user = @exchangepost.user
    @comment = Comment.new
    @comments = @exchangepost.comments.includes({ user: { image_attachment: :blob } })
  end

  def new
    @exchangepost = current_user.exchangeposts.build
  end

  def create
    @exchangepost = current_user.exchangeposts.build(exchangepost_params)
    if @exchangepost.save
      flash[:notice] = t('.success')
      redirect_to @exchangepost
    else
      render 'exchangeposts/new', status: :unprocessable_entity
    end
  end

  def destroy
    @exchangepost = Exchangepost.find(params[:id])
    @user = @exchangepost.user
    @exchangepost.destroy
    flash[:notice] = t('.success')
    redirect_to exchangeposts_user_path(@user), status: :see_other
  end

  private

  def exchangepost_params
    params.require(:exchangepost).permit(:give_item_name, :give_item_description, :want_item_name,
                                         :want_item_description, :place, images: [])
  end

  def correct_user
    @exchangepost = Exchangepost.find(params[:id])
    return if @exchangepost.user == current_user

    redirect_to root_path, alert: '他のユーザーの投稿は削除できません'
  end
end

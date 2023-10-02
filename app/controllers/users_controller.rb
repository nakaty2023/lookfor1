class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:profile]
  before_action :correct_user, only: [:profile]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @shopposts = @user.shopposts.includes(:shop, { images_attachments: :blob })
  end

  def profile
    @user = User.find(params[:id])
  end

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments.includes(exchangepost: :user)
  end

  def exchangeposts
    @user = User.find(params[:id])
    @exchangeposts = @user.exchangeposts.includes({ images_attachments: :blob })
  end

  private

  def correct_user
    @user = User.find(params[:id])
    return if @user == current_user

    redirect_to root_path, alert: '不正なアクセスです。'
  end
end

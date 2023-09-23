class UsersController < ApplicationController
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
end

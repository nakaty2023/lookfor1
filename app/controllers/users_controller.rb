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
end

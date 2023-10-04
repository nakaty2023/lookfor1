class ShoppostsController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :correct_user, only: :destroy

  def create
    @shoppost = if user_signed_in?
                  current_user.shopposts.build(shoppost_params)
                else
                  Shoppost.new(shoppost_params)
                end
    if @shoppost.save
      flash[:notice] = t('.success')
      @shop = @shoppost.shop
      redirect_to @shop
    else
      @shop = Shop.find(@shoppost.shop_id)
      @shopposts = @shop.shopposts.includes(:user, { images_attachments: :blob })
      render 'shops/show', status: :unprocessable_entity
    end
  end

  def destroy
    @shop = @shoppost.shop
    @shoppost.destroy
    flash[:notice] = t('.success')
    redirect_to @shop, status: :see_other
  end

  private

  def shoppost_params
    params.require(:shoppost).permit(:content, :shop_id, images: [])
  end

  def correct_user
    @shoppost = current_user.shopposts.find(params[:id])
    redirect_to root_url, status: :see_other if @shoppost.nil?
  end
end

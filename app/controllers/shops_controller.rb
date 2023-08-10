class ShopsController < ApplicationController
  def index
    @shops = Shop.includes(:items).all
  end

  def show
    @shop = Shop.find(params[:id])
    @shoppost = Shoppost.new
    @shopposts = @shop.shopposts.includes(:user)
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to @shop
    else
      render :new
    end
  end

  def destroy
    Shop.find(params[:id]).destroy
    redirect_to shops_url, status: :see_other
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end

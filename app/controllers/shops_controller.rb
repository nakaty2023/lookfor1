class ShopsController < ApplicationController
  def show
    @shop = Shop.find(params[:id])
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

  private

  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end

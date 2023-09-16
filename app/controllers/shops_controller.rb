class ShopsController < ApplicationController
  def index
    @q = Shop.ransack(params[:q])
    @shops = @q.result(distinct: true).includes(:items).limit(10)
  end

  def search
    @q = Shop.ransack(params[:q])
    @user_latitude = params[:q].try(:[], :lat)
    @user_longitude = params[:q].try(:[], :lon)
    @shops = if @user_latitude.present? && @user_longitude.present?
               @q.result(distinct: true).includes(:items).near([@user_latitude, @user_longitude], 5).limit(10)
             else
               @q.result(distinct: true).includes(:items).limit(10)
             end
  end

  def show
    @shop = Shop.find(params[:id])
    @shoppost = Shoppost.new
    @shopposts = @shop.shopposts.includes(:user, { images_attachments: :blob })
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

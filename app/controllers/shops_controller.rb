class ShopsController < ApplicationController
  before_action :ensure_location_present, only: :search

  def index
    if params[:q_shops].blank? ||
       (params[:q_shops][:name_cont].blank? &&
        params[:q_shops][:items_name_cont].blank? &&
        params[:q_shops][:address_cont].blank?)

      flash[:alert] = 'いずれかの入力フォームに、検索条件を入力してください'
      redirect_to root_path
      return
    end
    @q = Shop.ransack(params[:q_shops])
    @shops = @q.result(distinct: true).includes(:items).limit(10)
    flash.now[:alert] = '店舗が見つかりませんでした' if @shops.empty?
  end

  def search
    @q = Shop.ransack(params[:q_shops])
    @shops = @q.result(distinct: true).includes(:items).near([@user_latitude, @user_longitude], 5).limit(10)
    flash.now[:alert] = '店舗が見つかりませんでした' if @shops.empty?
  end

  def show
    @shop = Shop.find(params[:id])
    @shoppost = Shoppost.new
    @shopposts = @shop.shopposts.includes(:user, { images_attachments: :blob }, user: { image_attachment: :blob })
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

  def ensure_location_present
    @user_latitude = params[:q_shops].try(:[], :lat)
    @user_longitude = params[:q_shops].try(:[], :lon)

    return if @user_latitude.present? && @user_longitude.present?

    flash[:alert] = '位置情報が取得できませんでした'
    redirect_to root_path
  end
end

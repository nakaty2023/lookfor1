class ShoppostsController < ApplicationController
  def create
    @shoppost = if user_signed_in?
                  current_user.shopposts.build(shoppost_params)
                else
                  Shoppost.new(shoppost_params)
                end
    if @shoppost.save
      flash[:notice] = '投稿が完了しました'
      redirect_to root_url
    else
      @shop = Shop.find(params[:id])
      render 'shops/show', status: :unprocessable_entity
    end
  end

  private

  def shoppost_params
    params.require(:shoppost).permit(:content, :shop_id)
  end
end

class HomesController < ApplicationController
  def home
    @q_shops = Shop.ransack(params[:q_shops])
    @q_exchangeposts = Exchangepost.ransack(params[:q_exchangeposts])
  end
end

class HomesController < ApplicationController
  def home
    @q = Shop.ransack(params[:q])
  end
end

class ApplicationController < ActionController::Base
  def test
    if @shop
      @shop = Shop.first
      render html: "#{@shop.name} - #{@shop.address}"
    else
      render html: "hello world"
    end
  end
end

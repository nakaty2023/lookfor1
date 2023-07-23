class ApplicationController < ActionController::Base
  def test
    @shop = Shop.first
    render html: "#{@shop.name} - #{@shop.address}"
  end
end

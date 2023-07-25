class ApplicationController < ActionController::Base
  def test
    item = Item.first
    render html: "#{item.name}-#{item.url}"
  end
end

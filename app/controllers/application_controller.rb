class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def test
    item = Item.first
    user = User.first
    render html: "#{item.name}-#{item.url} #{user.name}-#{user.email}"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name gender age])
  end
end

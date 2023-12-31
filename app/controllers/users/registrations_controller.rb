# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :convert_gender_to_integer, only: %i[create update]
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update
  before_action :ensure_normal_user, only: %i[edit update destroy]

  private

  def convert_gender_to_integer
    params[:user][:gender] = params[:user][:gender].to_i if params[:user][:gender].present?
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name gender age image])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name gender age image])
  end

  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  def after_update_path_for(resource)
    profile_user_path(resource)
  end

  def ensure_normal_user
    return unless resource.email == 'guest@example.com'

    redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

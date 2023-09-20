class ExchangepostsController < ApplicationController

  def index
    @exchangeposts = Exchangepost.all.includes(:user, { images_attachments: :blob })
  end

  def new
    @exchangepost = current_user.exchangeposts.build
  end

  def create
    @exchangepost = current_user.exchangeposts.build(exchangepost_params)
    if @exchangepost.save
      flash[:notice] = t('.success')
      redirect_to exchangeposts_path
    else
      render 'exchangeposts/new', status: :unprocessable_entity
    end
  end

  private

  def exchangepost_params
    params.require(:exchangepost).permit(:give_item_name, :give_item_description, :want_item_name, :want_item_description, :place, images: [])
  end
end

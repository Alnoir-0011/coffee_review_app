class ShopsController < ApplicationController
  
  def index
    @q = Shop.ransack(params[:q])
    # if params[:current_location].empty?
    @shops = @q.result
    # else
    #   @shop = Shop.near(params[:current_location], 10, units: :km)
    # end
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      redirect_to mypage_purchases_path, success: '店舗を登録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :place_id, :address, :phone_number, :latitude, :longitude)
  end
end

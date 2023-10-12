class ShopsController < ApplicationController
  
  def index
    @lat = params[:lat]
    @lng = params[:lng]
    @q = Shop.ransack(params[:q])
    @shops = if @lat && @lng
               Shop.near([@lat, @lng], 10, units: :km)
             elsif params[:q].present? && params[:q][:name_cont].present?
               @q.result
             else
               Shop.near([35.6809591, 139.7673068], 10, units: :km)
             end
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

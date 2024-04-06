class ShopsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  def index
    @lat = params[:lat]
    @lng = params[:lng]
    @q = Shop.ransack(params[:q])
    if @lat && @lng
      @shops = Shop.near([@lat, @lng], 10, units: :km)
      @search_explanation = t('.near_by_current_location')
    elsif params[:q].present?
      @shops = @q.result

      if params[:q][:name_cont].present?
        @search_explanation = t('.name_include', item: params[:q][:name_cont])
      elsif params[:q][:place_id_eq].present?
        @search_explanation = @shops.first.name
      end
    else
      @shops = Shop.near([35.6809591, 139.7673068], 3, units: :km)
      @search_explanation = t('.arround_tokyo')
    end
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    @shop.add_google_map_uri

    if @shop.save
      redirect_to mypage_purchases_path, success: t('defaults.message.registered', item: Shop.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @shops = Shop.where("name like ?", "%#{params[:q]}%")
    render layout: false
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :place_id, :address, :latitude, :longitude)
  end
end

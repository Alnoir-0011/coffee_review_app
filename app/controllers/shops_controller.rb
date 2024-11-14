class ShopsController < ApplicationController
  skip_before_action :require_login, only: %i[index search reviews]

  def index
    return unless params[:CONTENT_TYPE] == 'application/json'

    lat = params[:lat]
    lng = params[:lng]
    q = Shop.ransack(params[:q])

    shops = if lat && lng
              Shop.near([lat, lng], 10, units: :km)
            elsif params[:q].present?
              q.result
            else
              Shop.near([35.6809591, 139.7673068], 3, units: :km)
            end

    render json: ShopSerializer.new(shops).serializable_hash.to_json
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
    @shops = Shop.where('name like ?', "%#{params[:q]}%")
    render layout: false
  end

  def reviews
    shop = Shop.find(params[:id])
    reviews = shop.reviews.limit(3).includes(purchase: :bean)
    render json: ReviewSerializer.new(reviews).serializable_hash.to_json
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :place_id, :address, :latitude, :longitude)
  end
end

class Admin::ShopsController < Admin::BaseController
  before_action :set_shop, only: %i[edit update destroy]

  def index
    @q = Shop.ransack(params[:q], auth_object: current_user)
    @shops = @q.result.includes(:beans, :reviews).page(params[:page])
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      redirect_to admin_shops_path, success: 'create successful'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @shop.update(shop_params)
      redirect_to admin_shops_path, success: 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shop.destroy!
    flash.now[:success] = 'shop deleted'
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :place_id, :address, :phone_number, :latitude, :longitude)
  end
end

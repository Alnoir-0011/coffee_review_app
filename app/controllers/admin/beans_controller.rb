class Admin::BeansController < Admin::BaseController
  before_action :set_bean, only: %i[edit update destroy]

  def index
    @q = Bean.ransack(params[:q], auth_object: current_user)
    @beans = @q.result.includes(:purchases, :reviews, :region).page(params[:page])
  end

  def new
    @bean = Bean.new
  end

  def create
    @bean = Bean.new(bean_params)
    @shops = Shop.where(place_id: params[:bean][:shop_ids].split(','))

    if @bean.save_with_shops(@shops)
      redirect_to admin_beans_path, success: 'create successful'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shops = @bean.shops
  end

  def update
    @shops = Shop.where(place_id: params[:bean][:shop_ids].split(','))
    @bean.assign_attributes(bean_params)

    if @bean.save_with_shops(@shops)
      redirect_to admin_beans_path, success: 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bean.destroy!
    flash.now[:success] = 'bean deleted'
  end

  private

  def set_bean
    @bean = Bean.find(params[:id])
  end

  def bean_params
    params.require(:bean).permit(:name, :roast, :fineness, :region_id)
  end
end

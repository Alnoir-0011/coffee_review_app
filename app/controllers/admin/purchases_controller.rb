class Admin::PurchasesController < Admin::BaseController
  before_action :set_purchase, only: %i[edit update destroy]

  def index
    @q = Purchase.ransack(params[:q], auth_object: current_user)
    @purchases = @q.result.includes(:user, :bean, :shop).page(params[:page])
  end

  def edit
    @purchase_form = PurchaseForm.new(purchase: @purchase)
  end

  def update
    @purchase_form = PurchaseForm.new(purchase_form_params, purchase: @purchase)
    if @purchase_form.update
      redirect_to admin_purchases_path, success: 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destory
    @purchase.destroy!
    flash.now[:success] = 'delete successful'
  end

  private

  def purchase_form_params
    params.require(:purchase).permit(:shop_name, :shop_place_id, :bean_name, :bean_id,
                                     :store_roast_option, :store_grind_option, :purchase_at).merge(user_id: current_user.id)
  end

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end
end

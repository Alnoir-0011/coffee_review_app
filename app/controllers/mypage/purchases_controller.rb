class Mypage::PurchasesController < ApplicationController
  before_action :set_purchases, only: %i[edit update destroy]
  before_action :set_purchase_form, only: %i[edit update]

  def index
    @q = current_user.purchases.ransack(params[:q])
    @purchases = @q.result.includes(:bean, :shop).order(purchase_at: :desc).page(params[:page])
  end

  def new
    @purchase_form = PurchaseForm.new
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_form_params)
    if @purchase_form.save
      redirect_to mypage_purchases_path, success: '購入記録を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @purchase_form.assign_attributes(purchase_form_params)
    if @purchase_form.save
      redirect_to mypage_purchases_path, success: '購入記録を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @purchase.destroy!
    flash.now[:success] = '購入記録を削除しました'
  end

  private

  def purchase_form_params
    params.require(:purchase_form).permit(:shop_name, :bean_name,
      :store_roast_option, :store_grind_option, :purchase_at).merge(user_id: current_user.id)
  end

  def set_purchases
    @purchase = current_user.purchases.find(params[:id])
  end

  def set_purchase_form
    @purchase_form = PurchaseForm.new(shop_name: @purchase.shop.name, bean_name: @purchase.bean.name,
                     store_roast_option: @purchase.store_roast_option, store_grind_option: @purchase.store_grind_option,
                     purchase_at: @purchase.purchase_at)
  end
end

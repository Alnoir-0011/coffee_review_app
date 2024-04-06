class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[edit update]
  before_action :set_purchase_form, only: %i[edit]

  def new
    @purchase_form = PurchaseForm.new
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_form_params)
    if @purchase_form.save
      redirect_to mypage_purchases_path, success: t('defaults.message.created', item: Purchase.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @purchase_form = PurchaseForm.new(purchase_form_params, purchase: @purchase)
    if @purchase_form.update
      redirect_to mypage_purchases_path, success: t('defaults.message.updated', item: Purchase.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def purchase_form_params
    params.require(:purchase).permit(:shop_name, :shop_place_id, :bean_name, :bean_id,
      :store_roast_option, :store_grind_option, :purchase_at).merge(user_id: current_user.id)
  end

  def set_purchase
    @purchase = current_user.purchases.find(params[:id])
  end

  def set_purchase_form
    @purchase_form = PurchaseForm.new(purchase: @purchase)
  end
end

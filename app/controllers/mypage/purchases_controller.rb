class Mypage::PurchasesController < ApplicationController
  before_action :set_purchases, only: %i[destroy]

  def index
    @q = current_user.purchases.ransack(params[:q])
    @purchases = @q.result.includes(:bean, :shop, :review).order(purchase_at: :desc).page(params[:page])
  end

  def destroy
    @purchase.destroy!
    flash.now[:success] = t('default.message.deleted', item: Purchase.model_name.human)
  end

  private

  def set_purchases
    @purchase = current_user.purchases.find(params[:id])
  end
end

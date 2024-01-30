class Mypage::ReviewsController < ApplicationController
  before_action :set_review, only: %i[destroy]

  def index
    @q = current_user.reviews.ransack(params[:q])
    @reviews = @q.result.includes(:brewing_method, :tools, purchase: :bean).page(params[:page])
  end

  def destroy
    @review.destroy
    flash.now[:success] = t('default.message.deleted', item: Review.model_name.human)
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end
end

class ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update image]

  def new
    @purchase = current_user.purchases.find(params[:purchase_id])
    redirect_to mypage_reviews_path, alert: t('defaults.message.already_taken', item: Review.model_name.human) if @purchase.reviews.present?

    @review = @purchase.reviews.new
  end

  def create
    @purchase = current_user.purchases.find(params[:purchase_id])
    redirect_to mypage_reviews_path, alert: t('defaults.message.already_taken', item: Review.model_name.human) if @purchase.reviews.present?

    @review = @purchase.reviews.new(review_params)
    if @review.save_with_tools(form_tool_ids: params[:review][:tool_ids])
      redirect_to mypage_reviews_path, success: t('defaults.message.posted', item: Review.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @review.assign_attributes(review_params)

    if @review.save_with_tools(form_tool_ids: params[:review][:tool_ids])
      redirect_to mypage_reviews_path, success: t('defaults.message.updated', item: Review.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def image; end

  private

  def review_params
    params.require(:review).permit(:title, :fineness, :evaluation, :content, :brewing_method_id, :image, :image_cache)
  end

  def set_review
    @review = current_user.reviews.find(params[:id])
  end
end

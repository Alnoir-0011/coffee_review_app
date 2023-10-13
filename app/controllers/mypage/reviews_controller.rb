class Mypage::ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update destroy]
  def index
    @q = current_user.reviews.ransack(params[:q])
    @reviews = @q.result.includes(:brewing_method, :tools, purchase: :bean).page(params[:page])
  end

  def new
    @purchase = current_user.purchases.find(params[:purchase])
    @review = @purchase.build_review
  end

  def create
    @purchase = current_user.purchases.find(params[:review][:purchase_id])
    @review = @purchase.build_review(review_params)
    if @review.save_with_tools(form_tool_ids: params[:review][:tool_ids])
      redirect_to mypage_reviews_path, success: 'レビューを投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @review.assign_attributes(review_params)

    if @review.save_with_tools(form_tool_ids: params[:review][:tool_ids])
      redirect_to mypage_reviews_path, success: 'レビューを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    flash.now[:success] = 'レビューを削除しました'
  end

  private

  def review_params
    params.require(:review).permit(:title, :fineness, :evaluation, :content, :brewing_method_id)
  end

  def set_review
    @review = current_user.reviews.find(params[:id])
  end
end

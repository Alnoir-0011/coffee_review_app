class Admin::ReviewsController < Admin::BaseController
  before_action :set_review, only: %i[edit update destroy]

  def index
    @q = Review.ransack(params[:q])
    @reviews = @q.result.includes(purchase: [:bean, :user])
  end

  def edit; end

  def update
    @review.assign_attributes(review_params)
    if @review.save_with_tools(form_tool_ids: params[:review][:tool_ids])
      redirect_to admin_reviews_path, success: 'update successful'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
    flash.now[:success] = 'delete successful'
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:title, :fineness, :evaluation, :content, :brewing_method_id,)
  end
end

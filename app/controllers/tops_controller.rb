class TopsController < ApplicationController
  skip_before_action :require_login

  def index
    @top_sliders = TopSlider.all
    @regions = Region.all
    @q = Review.ransack(params[:q])

    @reviews = if current_user&.recommended_reviews.present?
                 current_user.recommended_reviews.includes(:brewing_method, purchase: :bean).page(params[:page]).per(10)
               else
                 Review.all.includes(:brewing_method, purchase: :bean).page(params[:page]).per(10)
               end
  end

  def search
    @top_sliders = TopSlider.all
    @regions = Region.all
    @q = Review.ransack(params[:q])
    @reviews = @q.result.includes(:brewing_method, purchase: :bean).page(params[:page]).per(10)
  end
end

class TopsController < ApplicationController
  skip_before_action :require_login
  def index
    @top_sliders = TopSlider.all
    @regions = Region.all
    @q = Review.ransack(params[:q])
    @reviews = @q.result.includes(purchase: :bean).page(params[:page]).per(10)
  end
end

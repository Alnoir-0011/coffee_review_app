class TopsController < ApplicationController
  skip_before_action :require_login
  def index
    @regions = Region.all
    @q = Bean.ransack(params[:q])
    @beans = @q.result.includes(:shops, purchases: :review).page(params[:page])
  end
end

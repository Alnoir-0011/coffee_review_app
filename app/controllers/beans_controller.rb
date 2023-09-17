class BeansController < ApplicationController
  skip_before_action :require_login
  def index
    @region = Region.find(params[:region])
    @q = @region.beans.ransack(params[:q])
    # @q = Bean.ransack(params[:q])
    @beans = @q.result.includes(:shops, purchases: :review).page(params[:page])
  end
end


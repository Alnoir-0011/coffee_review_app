class BeansController < ApplicationController
  def index
    @region = Region.find(params[:region])
    @q = @region.beans.ransack(params[:q])
    # @q = Bean.ransack(params[:q])
    @beans = @q.result.includes(:shops, purchases: :reviews).page(params[:page])
  end
end


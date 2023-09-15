class TopsController < ApplicationController
  def index
    @regions = Region.all
    @q = Bean.ransack(params[:q])
    @beans = @q.result.page(params[:page])
  end
end

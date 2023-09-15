class TopsController < ApplicationController
  def index
    @regions = Region.all
    @q = Bean.ransack(params[:q])
  end
end

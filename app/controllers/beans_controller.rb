class BeansController < ApplicationController
  def index
    # @category = Region.find_by(params[:category])
    # redirect_to root_path unless @category
    # if @category
    #   @q = @category.beans.ransack(params[:q])
    # else
    #   @q = Bean.ransack(params[:q])
    # end
    @q = Bean.ransack(params[:q])
    @beans = @q.result.page(params[:page])
  end
end


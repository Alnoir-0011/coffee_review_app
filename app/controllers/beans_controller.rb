class BeansController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    # binding.pry
    @region = Region.find(params[:region] || params[:q][:region_id])
    @q = @region.beans.ransack(params[:q])
    # @q = Bean.ransack(params[:q])
    @beans = @q.result.includes(:shops, purchases: :review).page(params[:page])
  end

  def show
    @bean = Bean.find(params[:id])
    @reviews = @bean.reviews.page(params[:page])
  end

  def new
    @bean = Bean.new
  end

  def create
    @bean = Bean.new(bean_params)
    if @bean.save
      redirect_to beans_path(region: params[:bean][:region_id]), success: 'コーヒー豆を登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bean_params
    params.require(:bean).permit(:name, :roast, :fineness, :region_id, :image)
  end
end

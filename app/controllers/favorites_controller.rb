class FavoritesController < ApplicationController
  before_action :set_bean, only: %i[create destroy]

  def create
    current_user.favorite(@bean)
    flash[:success] = t('.success', item: @bean.name)
  end

  def destroy
    current_user.unfavorite(@bean)
    flash[:success] = t('.success', item: @bean.name)
  end

  private

  def set_bean
    @bean = Bean.find(params[:bean_id])
  end
end

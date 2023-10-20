class FavoritesController < ApplicationController
  def create
    @bean = Bean.find(params[:bean_id])
    current_user.favorite(@bean)
    flash[:success] = "#{@bean.name}をお気に入り登録しました"
  end

  def destroy
    @bean = Bean.find(params[:bean_id])
    current_user.unfavorite(@bean)
    flash[:success] = "#{@bean.name}のお気に入り登録を解除しました"
  end
end

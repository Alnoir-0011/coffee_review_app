class UserProfilesController < ApplicationController
  skip_before_action :require_login

  def show
    # redirect_to mypage_purchases_path if params[:id].to_i == current_user.id
    @user = User.find(params[:id])
    @q = @user.reviews.ransack(params[:q])
    @reviews = @q.result.includes(:tools, :brewing_method, purchase: :bean).page(params[:page])
  end
end

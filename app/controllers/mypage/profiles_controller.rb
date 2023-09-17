class Mypage::ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def show; end

  def update
    @user.assign_attributes(user_params)
    if @user.save_with_associations(tool_ids: params[:user][:tool_ids], brewing_method_ids: params[:user][:brewing_method_ids])
      flash.now[:success] = 'プロフィールを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end

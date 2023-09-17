class Mypage::ProfileController < ApplicationController
  def edit
  end

  def show; end

  def update
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_param
    params.require(:user).permit(:name, :email, :tool_ids, )
  end
end

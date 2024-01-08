class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result
  end

  def edit; end
  
  def update
    if @user.update(user_params)
      redirect_to admin_users_path, success: 'user updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_users_path, success: 'user deleted'
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :avatar_cache, :role)
  end
end

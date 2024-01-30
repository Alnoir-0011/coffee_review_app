class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    
    if @user
      flash[:success] = t('.success')
      redirect_back_or_to root_path
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = t('.success')
    redirect_to login_path, status: :see_other
  end
end

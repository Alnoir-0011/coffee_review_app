class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password])
    
    if @user
      flash[:success] = 'Login successful'
      redirect_back_or_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = 'Logut successful'
    redirect_to login_path
  end
end

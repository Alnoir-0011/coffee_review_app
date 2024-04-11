class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :admin_authenticate, only: %i[new create]
  layout 'admin/layouts/login'

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to admin_root_path, success: 'Login successful'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = 'Logut successful'
    redirect_to admin_login_path, status: :see_other
  end
end

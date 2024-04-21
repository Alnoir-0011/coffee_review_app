class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      redirect_back_or_to root_path, success: t('.success', item: provider.titleize)
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, success: t('.success', item: provider.titleize)
      rescue StandardError
        redirect_to login_path, danger: t('.fail', item: provider.titleize)
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end

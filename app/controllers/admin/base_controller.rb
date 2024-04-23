class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :admin_authenticate
  layout 'admin/layouts/application'

  private

  def not_authenticated
    redirect_to admin_login_path, danger: t('defaults.message.require_login')
  end

  def admin_authenticate
    redirect_to root_path, warning: 'admin only' unless current_user.admin?
  end
end

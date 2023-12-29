class Admin::BaseController < ApplicationController
  # before_action :require_login
  layout 'admin/layouts/application'

  def index

  end

  private

  def not_authenticated
    redirect_to admin_login_path, danger: 'require login'
  end
end

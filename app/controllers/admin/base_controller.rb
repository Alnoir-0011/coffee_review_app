class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :admin_authenticate
  layout 'admin/layouts/application'

  def index
    @most_reviewed_shop = Shop.joins(:reviews).group("shops.name").order('count_all DESC').limit(1).count.to_a[0]
    @monthly_reviewed_shop = Shop.joins(:reviews).where("shops.created_at > ?", Time.current.prev_month).group("shops.name").order('count_all DESC').limit(1).count.to_a[0]
  end

  private

  def not_authenticated
    redirect_to admin_login_path, danger: 'require login'
  end

  def admin_authenticate
    redirect_to root_path, warning: 'admin only' unless current_user.admin?
  end
end

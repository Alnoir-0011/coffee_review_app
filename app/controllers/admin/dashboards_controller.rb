class Admin::DashboardsController < Admin::BaseController
  def index
    @most_reviewed_shop = Shop.joins(:reviews).group('shops.name').order('count_all DESC').limit(1).count.to_a[0]
    @monthly_reviewed_shop = Shop.joins(:reviews).where('shops.created_at > ?', Time.current.prev_month)
                                 .group('shops.name').order('count_all DESC').limit(1).count.to_a[0]
  end
end

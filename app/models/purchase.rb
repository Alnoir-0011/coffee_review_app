class Purchase < ApplicationRecord
  include GroupByDay

  belongs_to :user
  belongs_to :bean
  belongs_to :shop
  has_one :review, dependent: :destroy

  validates :purchase_at, presence: true

  validate :future_dates_cannot
  validate :prohibited_before_roasting

  enum :store_roast_option,
       { roasted: 0, light: 10, chinamon: 20, medium: 30, high: 40, city: 50, fullcity: 60, french: 70, italian: 80 }, prefix: true
  enum :store_grind_option,
       { grinded: 0, beans: 10, coarsely: 20, medium: 30, medium_fine: 40, fine: 50, superfine: 60 }, prefix: true

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : %w[store_roast_option store_grind_option]
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : %w[bean shop]
  end

  def roast_status
    if store_roast_option_roasted?
      bean.roast_i18n
    else
      store_roast_option_i18n
    end
  end

  def grind_situation
    if store_grind_option_grinded?
      bean.fineness_i18n
    else
      store_grind_option_i18n
    end
  end

  private

  def future_dates_cannot
    errors.add(:purchase_at, 'は未来の日付は登録できません') if purchase_at.after? Date.today
  end

  def prohibited_before_roasting
    return unless Bean.find(bean_id).roast_raw? && store_roast_option_roasted?

    errors.add(:store_roast_option, 'このコーヒー豆は焙煎前で登録できません')
  end

  def cannot_grind_again
    return if Bean.find(bean_id).fineness_beans? || store_grind_option_grinded?

    errors.add(:store_grind_option, 'このコーヒー豆は粉砕済みです')
  end
end

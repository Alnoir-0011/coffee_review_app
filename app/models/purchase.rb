class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :bean
  belongs_to :shop
  has_one :review, dependent: :destroy

  validates :purchase_at, presence: true

  validate :future_dates_cannot
  validate :prohibited_before_roasting

  enum :store_roast_option, { roasted: 0, light: 10, chinamon: 20, medium: 30, high: 40, city: 50, fullcity: 60, fremch: 70, italian: 80 }, prefix: true
  enum :store_grind_option, { grinded: 0, beans: 10, coarsely: 20, medium: 30, medium_fine: 40, fine: 50, superfine: 60 }, prefix: true


  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end

  private

  def future_dates_cannot
    errors.add(:purchase_at, "は未来の日付は登録できません") if self.purchase_at.after? Date.today
  end

  def prohibited_before_roasting
    if Bean.find(self.bean_id).roast_raw? && self.store_roast_option_roasted?
      errors.add(:store_roast_option, "このコーヒー豆は焙煎前で登録できません")
    end
  end

  def cannot_grind_again
    unless Bean.find(self.bean_id).fineness_beans? || self.store_grind_option_grinded?
      errors.add(:store_grind_option, "このコーヒー豆は粉砕済みです")
    end
  end
end

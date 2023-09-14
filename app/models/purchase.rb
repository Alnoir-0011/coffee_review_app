class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :bean
  belongs_to :shop
  has_many :reviews, dependent: :destroy

  validate :future_dates_cannot

  enum :store_roast_option, { light: 0, chinamon: 10, medium: 20, high: 30, city: 40, fullcity: 50, fremch: 60, italian: 70 }, prefix: true
  enum :store_grind_option, { beans: 0, coarsely: 10, medium: 20, medium_fine: 30, fine: 40, superfine: 50 }, prefix: true

  private

  def future_dates_cannot
    errors.add(:purchase_at, "は未来の日付は登録できません") if self.purchase_at > Date.today
  end
end

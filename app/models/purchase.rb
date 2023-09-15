class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :bean
  belongs_to :shop
  has_many :reviews, dependent: :destroy

  validate :future_dates_cannot

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
    errors.add(:purchase_at, "は未来の日付は登録できません") if self.purchase_at > Date.today
  end
end

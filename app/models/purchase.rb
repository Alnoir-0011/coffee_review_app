class Purchase < ApplicationRecord
  include GroupByDay

  belongs_to :user
  belongs_to :bean
  belongs_to :shop
  has_many :reviews, dependent: :destroy

  validates :purchase_at, presence: true
  validates :store_roast_option, presence: true
  validates :store_grind_option, presence: true

  validate :future_dates_cannot, if: -> { purchase_at }
  validate :prohibited_before_roasting, if: -> { bean && store_roast_option }
  validate :cannot_roast_again, if: -> { bean && store_roast_option }
  validate :cannot_grind_again, if: -> { bean && store_grind_option }
  validate :beans_cannot_regist_grinded, if: -> { bean && store_grind_option }

  enum :store_roast_option,
       { roasted: 0, light: 10, chinamon: 20, medium: 30, high: 40, city: 50, fullcity: 60, french: 70, italian: 80 },
       prefix: true
  enum :store_grind_option,
       { grinded: 0, beans: 10, coarsely: 20, medium: 30, medium_fine: 40, fine: 50, superfine: 60 },
       prefix: true

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
    errors.add(:purchase_at, 'は未来の日付は登録できません') if purchase_at.after? Time.zone.today
  end

  def prohibited_before_roasting
    return if !bean.roast_raw? || !store_roast_option_roasted?

    errors.add(:store_roast_option, "#{bean.name}は焙煎前です")
  end

  def cannot_roast_again
    return if bean.roast_raw? || store_roast_option_roasted?

    errors.add(:store_roast_option, "#{bean.name}は焙煎済みです")
  end

  def cannot_grind_again
    return if bean.fineness_beans? || store_grind_option_grinded?

    errors.add(:store_grind_option, "#{bean.name}は粉砕済みです")
  end

  def beans_cannot_regist_grinded
    return if !bean.fineness_beans? || !store_grind_option_grinded?

    errors.add(:store_grind_option, "#{bean.name}は粉砕前です")
  end
end

class PurchaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :shop_name, :string
  attribute :bean_name, :string
  attribute :store_roast_option, :string
  attribute :store_grind_option, :string
  attribute :purchase_at, :date

  with_options presence: true do
    validates :shop_name, :bean_name, :store_roast_option, :store_grind_option, :purchase_at
  end

  validate :product_does_not_exist
  validate :shop_does_not_exist
  validate :future_dates_cannot, unless: -> { purchase_at.nil? }
  validate :prohibited_before_roasting, unless: -> { Bean.find_by(name: bean_name).nil? }

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      purchase.save!

      unless purchase.bean.include?(purchase.shop.beans)
        purchase.shop.bean << purchase.bean
      end
    end
  rescue StandardError
    false
  end
  
  def purchase
    @purchase ||= current_user.purchases.new(store_roast_option: store_roast_option,
                  store_grind_option: store_grind_option,purchase_at: purchase_at,
                  bean_id: Bean.find_by(name: bean_name, shop_id: Shop.find_by(name: shop_name)))
  end

  

  private

  def future_dates_cannot
    errors.add(:purchase_at, "は未来の日付は登録できません") if self.purchase_at.after? Date.today
  end

  def prohibited_before_roasting
    if Bean.find_by(name: self.bean_name).roast_raw? && self.store_roast_option == 'roasted'
      errors.add(:store_roast_option, "このコーヒー豆は焙煎前で登録できません")
    end
  end

  def cannot_grind_again
    unless Bean.find_by(name: self.bean_name).fineness_beans? || self.store_grind_option == 'grinded'
      errors.add(:store_grind_option, "このコーヒー豆は粉砕済みです")
    end
  end

  def product_does_not_exist
    errors.add(:bean_name, "商品が存在しません") unless Bean.find_by(name: self.bean_name)
  end

  def shop_does_not_exist
    errors.add(:shop_name, "店舗が存在しません") unless Shop.find_by(name: self.shop_name)
  end
end
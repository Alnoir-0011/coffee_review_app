class PurchaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :shop_name, :string
  attribute :bean_name, :string
  attribute :store_roast_option, :string
  attribute :store_grind_option, :string
  attribute :purchase_at, :date
  attribute :user_id, :integer

  with_options presence: true do
    validates :shop_name, :bean_name, :store_roast_option, :store_grind_option, :purchase_at
  end

  validate :product_does_not_exist
  validate :shop_does_not_exist
  validate :future_dates_cannot, unless: -> { purchase_at.nil? }
  validate :roast_status, unless: -> { Bean.find_by(name: bean_name).nil? }
  validate :grind_status,  unless: -> { Bean.find_by(name: bean_name).nil? }

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      purchase.save!

      unless purchase.shop.beans.include?(purchase.bean)
        purchase.shop.beans << purchase.bean
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

  def roast_status
    bean = Bean.find_by(name: self.bean_name)
    if bean.roast_raw? && self.store_roast_option == 'roasted'
      errors.add(:store_roast_option, "このコーヒー豆は焙煎前で登録できません")
    elsif !bean.roast_raw? && !self.store_roast_option == 'roasted'
      errors.add(:store_roast_option, "このコーヒー豆は焙煎済みです")
    end
  end

  def grind_status
    bean = Bean.find_by(name: self.bean_name)
    if !bean.fineness_beans? && !self.store_grind_option == 'grinded'
      errors.add(:store_grind_option, "このコーヒー豆は粉砕済みです")
    elsif bean.fineness_beans? && self.store_grind_option == 'grinded'
      errors.add(:store_grind_option, 'このコーヒー豆は粉砕前です')
    end
  end

  def product_does_not_exist
    errors.add(:bean_name, "商品が存在しません") unless Bean.find_by(name: self.bean_name)
  end

  def shop_does_not_exist
    errors.add(:shop_name, "店舗が存在しません") unless Shop.find_by(name: self.shop_name)
  end
end
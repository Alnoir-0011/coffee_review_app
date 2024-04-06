class PurchaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :shop_name, :string
  attribute :shop_place_id, :string
  attribute :bean_name, :string
  attribute :bean_id, :integer
  attribute :store_roast_option, :string
  attribute :store_grind_option, :string
  attribute :purchase_at, :date
  attribute :user_id, :integer

  with_options presence: true do
    validates :shop_name, :bean_name, :store_roast_option, :store_grind_option, :purchase_at
  end

  delegate :persisted?, to: :purchase

  validate :product_does_not_exist
  validate :shop_does_not_exist
  validate :future_dates_cannot, unless: -> { purchase_at.nil? }
  validate :roast_status, unless: -> { bean.nil? }
  validate :grind_status,  unless: -> { bean.nil? }

  def initialize(attributes = nil, purchase: Purchase.new)
    @purchase = purchase
    # binding.pry
    if @purchase.persisted? && attributes
      new_attributes = default_attributes.merge(attributes)
      super(new_attributes)
    elsif @purchase.persisted?
      new_attributes = default_attributes
      super(new_attributes)
    elsif
      super(attributes)
    end
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      # binding.pry
      @purchase.assign_attributes(user_id: user_id, shop_id: shop.id, bean_id: bean.id,
                                   store_roast_option: store_roast_option, store_grind_option: store_grind_option, purchase_at: purchase_at)

      @purchase.save!
      unless @purchase.shop.beans.include?(@purchase.bean)
      # binding.pry
        @purchase.shop.beans << @purchase.bean
      end
    end
    return true
  rescue StandardError
    false
  end

  def update
    return false if invalid?

    ActiveRecord::Base.transaction do
      @purchase.update!(shop_id: shop.id, bean_id: bean.id,
                        store_roast_option: store_roast_option, store_grind_option: store_grind_option, purchase_at: purchase_at)

      unless @purchase.shop.beans.include?(@purchase.bean)
        @purchase.shop.beans << @purchase.bean
      end
    end
    return true
  rescue StandardError
    false
  end

  def to_model
    purchase
  end

  private

  attr_reader :purchase

  def default_attributes
    {
      shop_name: @purchase.shop.name,
      shop_place_id: @purchase.shop.place_id,
      bean_name: @purchase.bean.name,
      bean_id: @purchase.bean_id,
      purchase_at: @purchase.purchase_at,
      store_roast_option: @purchase.store_roast_option,
      store_grind_option: @purchase.store_grind_option,
      user_id: @purchase.user_id
    }
  end

  def bean
    @bean ||= Bean.find_by(id: bean_id)
  end

  def shop
    @shop ||= Shop.find_by(place_id: shop_place_id)
  end

  # def purchase
  #   @purchase ||= User.find(self.user_id).purchases.new(store_roast_option: store_roast_option,
  #                 store_grind_option: store_grind_option,purchase_at: purchase_at,
  #                 bean_id: Bean.find_by(name: bean_name), shop_id: Shop.find_by(name: shop_name))
  # end

  def future_dates_cannot
    errors.add(:purchase_at, "は未来の日付は登録できません") if self.purchase_at.after? Date.today
  end

  def roast_status
    # bean = Bean.find_by(name: self.bean_name)
    if bean.roast_raw? && self.store_roast_option == 'roasted'
      errors.add(:store_roast_option, "このコーヒー豆は焙煎前で登録できません")
    elsif !bean.roast_raw? && !self.store_roast_option == 'roasted'
      errors.add(:store_roast_option, "このコーヒー豆は焙煎済みです")
    end
  end

  def grind_status
    # bean = Bean.find_by(name: self.bean_name)
    if !bean.fineness_beans? && !self.store_grind_option == 'grinded'
      errors.add(:store_grind_option, "このコーヒー豆は粉砕済みです")
    elsif bean.fineness_beans? && self.store_grind_option == 'grinded'
      errors.add(:store_grind_option, 'このコーヒー豆は粉砕前です')
    end
  end

  def product_does_not_exist
    errors.add(:bean_name, "商品が存在しません") unless bean_id.present? && bean # Bean.find_by(name: self.bean_name)
  end

  def shop_does_not_exist
    errors.add(:shop_name, "店舗が存在しません") unless shop_place_id.present? && shop # Shop.find_by(name: self.shop_name)
  end
end
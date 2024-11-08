class Bean < ApplicationRecord
  belongs_to :region
  has_many :dealers, dependent: :destroy
  has_many :shops, through: :dealers
  has_many :purchases, dependent: :destroy
  has_many :reviews, through: :purchases
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  validates :name, presence: true, length: { maximum: 255 }
  validates :roast, presence: true
  validates :fineness, presence: true

  validate :raw_cannot_grind, if: -> { roast.present? && fineness.present? }

  enum :roast,
       { raw: 0, light: 10, chinamon: 20, medium: 30, high: 40, city: 50, fullcity: 60, french: 70, italian: 80 },
       prefix: true

  enum :fineness, { beans: 0, coarsely: 10, medium: 20, medium_fine: 30, fine: 40, superfine: 50 },
       prefix: true

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : %w[id name roast fineness region_id]
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : %w[region]
  end

  def average_evaluation
    # reviews.average(:evaluation)
    # evs = reviews.pluck(:evaluation)
    evs = reviews.map(&:evaluation)
    evs.sum.fdiv(evs.length).round(2)
  end

  def image_url
    review_with_image = reviews.where.not(image: nil).order(like_count: :desc).limit(1)[0]
    review_with_image ? review_with_image.image.url : 'noimage.jpg'
  end

  def save_with_shops(shops)
    return false if invalid?

    ActiveRecord::Base.transaction do
      save!
      self.shops = shops
      true
    rescue StandardError
      false
    end
  end

  private

  def raw_cannot_grind
    return unless roast_raw? && !fineness_beans?

    errors.add(:fineness, '焙煎前のコーヒー豆は粉砕済みでは登録できません')
  end
end

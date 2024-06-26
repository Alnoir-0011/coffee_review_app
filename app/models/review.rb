class Review < ApplicationRecord
  include GroupByDay

  mount_uploader :image, ImageUploader

  belongs_to :purchase
  belongs_to :brewing_method
  has_many :review_tools, dependent: :destroy
  has_many :tools, through: :review_tools
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :recommendations, dependent: :destroy
  has_many :recommended_users, through: :recommendations, source: :user

  delegate :user, :bean, to: :purchase

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 65_535 }
  validates :fineness, presence: true
  validates :evaluation, numericality: { in: 1..5, message: 'を選択してください' }
  validates :purchase_id, uniqueness: { message: '1つにつきレビュー投稿は1度までしかできません' }
  validate :fineness_status, if: -> { purchase && fineness }

  enum :fineness, { grinded: 0, coarsely: 10, medium: 20, medium_fine: 30, fine: 40, superfine: 50 }, prefix: true

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : %w[title evaluation created_at like_count]
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : %w[purchase tools brewing_method]
  end

  def grind_status
    if fineness_grinded?
      purchase.grind_situation
    else
      fineness_i18n
    end
  end

  def save_with_tools(form_tool_ids:)
    ActiveRecord::Base.transaction do
      self.tools = form_tool_ids.reject(&:empty?).map { |id| Tool.find(id) }
      save!
    end
    true
  rescue StandardError
    false
  end

  def tool_ids
    tools.ids
  end

  def already_grinded?
    !purchase.store_grind_option_beans?
  end

  def own?(user)
    user.id == self.user.id
  end

  private

  def fineness_status
    if !purchase.store_grind_option_beans? && !fineness_grinded?
      errors.add(:fineness, '既に粉砕済みです')
    elsif purchase.store_grind_option_beans? && fineness_grinded?
      errors.add(:fineness, '粉砕前です')
    end
  end
end

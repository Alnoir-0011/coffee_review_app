class Review < ApplicationRecord
  belongs_to :purchase
  belongs_to :brewing_method
  has_many :review_tools, dependent: :destroy
  has_many :tools, through: :review_tools

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 65535 }
  validates :evaluation, numericality: { in: 1..5 }
  validates :purchase_id, uniqueness: true

  enum :fineness, { grinded: 0, coarsely: 10, medium: 20, medium_fine: 30, fine: 40, superfine: 50 }, prefix: true

  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end

  def grind_status
    if fineness_grinded?
      purchase.grind_situation
    else
      fineness
    end
  end

  def save_with_tools(tool_ids:)
    ActiveRecord::Base.transaction do
      self.tools = tool_ids.reject(&:empty?).map { |id| Tool.find(id) }
      save!
    end
    true
  rescue StandardError
    false
  end

  def tool_ids
    tools.ids
  end
end

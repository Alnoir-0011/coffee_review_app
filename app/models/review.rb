class Review < ApplicationRecord
  belongs_to :purchase
  belongs_to :brewing_method

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 65535 }
  validates :evaluation, numericality: { in: 1..5 }

  enum :fineness, { grinded: 0, coarsely: 10, medium: 20, medium_fine: 30, fine: 40, superfine: 50 }, prefix: true
end
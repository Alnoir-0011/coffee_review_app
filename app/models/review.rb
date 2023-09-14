class Review < ApplicationRecord
  belongs_to :purchase
  belongs_to :brewing_method

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 65535 }
  validates :evaluation, numericality: { in: 1..5 }

  enum :fineness, { coarsely: 0, medium: 10, medium_fine: 20, fine: 30, superfine: 40 }, prefix: true
end

class Dealer < ApplicationRecord
  belongs_to :bean
  belongs_to :shop

  validates :shop_id, uniqueness: { scope: :bean_id }
end

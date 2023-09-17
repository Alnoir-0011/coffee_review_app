class BrewingPrefence < ApplicationRecord
  belongs_to :user
  belongs_to :brewing_method

  validates :brewing_method_id, uniqueness: { scope: :user_id }
end

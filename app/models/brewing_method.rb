class BrewingMethod < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end

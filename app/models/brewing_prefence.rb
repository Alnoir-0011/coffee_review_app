class BrewingPrefence < ApplicationRecord
  belongs_to :user
  belongs_to :brewing_methods
end

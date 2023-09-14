class Region < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end

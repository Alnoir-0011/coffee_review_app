class Region < ApplicationRecord
  authorizable_ransackable_attributes
  
  has_many :beans, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

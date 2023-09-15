class BrewingMethod < ApplicationRecord
  has_many :reviews, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end
end

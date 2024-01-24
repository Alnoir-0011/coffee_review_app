class BrewingMethod < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :brewing_prefences, dependent: :destroy
  has_many :users, through: :brewing_prefences
  
  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : %(name)
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : []
  end
end

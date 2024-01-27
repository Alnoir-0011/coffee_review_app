class Shop < ApplicationRecord
  geocoded_by latitude: :latitude, longitude: :longitude

  has_many :dealers, dependent: :destroy
  has_many :beans, through: :dealers
  has_many :purchases, dependent: :destroy
  has_many :reviews, through: :purchases

  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }
  validates :place_id, presence: true, uniqueness: true
  validates :place_id, length: { maximum: 255 }
  validates :address, presence: true, uniqueness: true
  validates :address, length: { maximum: 255 }
  validates :phone_number, length: { maximum: 15 }, if: -> { phone_number }
  validates :latitude, presence: true
  validates :latitude, numericality: { in: 20..46 }
  validates :longitude, presence: true
  validates :longitude, numericality: { in: 120..150 }

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : %w(name)
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : []
  end
end

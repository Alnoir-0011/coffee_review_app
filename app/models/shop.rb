class Shop < ApplicationRecord
  include PlaceDetails

  geocoded_by latitude: :latitude, longitude: :longitude

  has_many :dealers, dependent: :destroy
  has_many :beans, through: :dealers
  has_many :purchases, dependent: :destroy
  has_many :reviews, through: :purchases

  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }
  validates :place_id, presence: true, uniqueness: true
  validates :place_id, length: { maximum: 255 }
  validates :address, presence: true
  validates :address, length: { maximum: 255 }
  validates :latitude, presence: true
  validates :latitude, numericality: { in: 20..46 }
  validates :longitude, presence: true
  validates :longitude, numericality: { in: 120..150 }
  validates :google_map_uri, presence: true, uniqueness: true
  validates :google_map_uri, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : %w(name place_id)
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : []
  end
end

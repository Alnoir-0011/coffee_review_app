class Region < ApplicationRecord
  has_many :beans, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : []
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : []
  end
end

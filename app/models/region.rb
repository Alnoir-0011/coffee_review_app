class Region < ApplicationRecord
  has_many :beans, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

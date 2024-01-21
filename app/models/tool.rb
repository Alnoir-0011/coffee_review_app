class Tool < ApplicationRecord
  has_many :uesr_tools, dependent: :destroy
  has_many :users, through: :user_tools
  has_many :review_tools, dependent: :destroy
  has_many :reviews, through: :review_tools
  
  validates :name, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    auth_object&.admin? ? super : %w(name)
  end

  def self.ransackable_associations(auth_object = nil)
    auth_object&.admin? ? super : []
  end
end

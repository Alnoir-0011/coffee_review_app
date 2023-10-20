class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :bean

  validates :bean_id, uniqueness: { scope: :user_id }
end

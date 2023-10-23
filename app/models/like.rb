class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review
  counter_culture :review, column_name: 'like_count'

  validates :review_id, uniqueness: { scope: :user_id }
end

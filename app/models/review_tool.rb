class ReviewTool < ApplicationRecord
  belongs_to :review
  belongs_to :tool

  validates :review_id, uniqueness: { scope: :tool_id }
end

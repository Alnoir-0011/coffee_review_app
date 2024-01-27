class AddLikeCountToReviews < ActiveRecord::Migration[7.0]
  def self.up
    add_column :reviews, :like_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :reviews, :like_count
  end
end

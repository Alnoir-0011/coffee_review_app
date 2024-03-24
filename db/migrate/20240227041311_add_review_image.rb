class AddReviewImage < ActiveRecord::Migration[7.0]
  def change
    remove_column :beans, :image, :json
    add_column :reviews, :image, :json
  end
end

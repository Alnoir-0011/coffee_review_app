class PurchaseHasOneReview < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :reviews, :purchases
    remove_reference :reviews, :purchase, index: true
    add_reference :reviews, :purchase, index: { unique: true }, foreign_key: true
  end
end

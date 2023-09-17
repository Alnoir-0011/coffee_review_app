class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.integer :store_roast_option, null: false, default: 0
      t.integer :store_grind_option, null: false, default: 0
      t.date :purchase_at, null: false
      t.references :user, null: false, foreign_key: true
      t.references :bean, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end

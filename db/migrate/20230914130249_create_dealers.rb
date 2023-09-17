class CreateDealers < ActiveRecord::Migration[7.0]
  def change
    create_table :dealers do |t|
      t.references :bean, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end

    add_index :dealers, [:bean_id, :shop_id], unique: true
  end
end

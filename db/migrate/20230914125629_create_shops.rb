class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :telephone_number
      t.string :adress

      t.timestamps
    end
  end
end

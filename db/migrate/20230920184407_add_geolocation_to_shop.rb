class AddGeolocationToShop < ActiveRecord::Migration[7.0]
  def change
    remove_column :shops, :telephone_number, :integer
    remove_column :shops, :adress, :string
    add_column :shops, :place_id, :string, null: false, index: { unique: true }
  end
end

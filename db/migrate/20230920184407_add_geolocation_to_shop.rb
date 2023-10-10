class AddGeolocationToShop < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :place_id, :string, null: false, index: { unique: true }
    add_column :shops, :latitude, :float
    add_column :shops, :longitude, :float
    rename_column :shops, :adress, :address
  end
end

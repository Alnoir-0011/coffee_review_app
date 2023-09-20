class AddGeolocationToShop < ActiveRecord::Migration[7.0]
  def change
    remove_column :shops, :telephone_number
    add_column :shops, :telephone_number, :string
    add_column :shops, :latutude, :float
    add_column :shops, :longitude, :float
  end
end

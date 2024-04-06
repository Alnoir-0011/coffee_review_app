class AddGoogleMapUriToShops < ActiveRecord::Migration[7.0]
  def change
    remove_column :shops, :phone_number, :string
    add_column :shops, :google_map_uri, :string
  end
end

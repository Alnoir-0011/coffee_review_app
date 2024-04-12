class AddShopsMapuriUnique < ActiveRecord::Migration[7.0]
  def change
    add_index :shops, :google_map_uri, unique: true
  end
end

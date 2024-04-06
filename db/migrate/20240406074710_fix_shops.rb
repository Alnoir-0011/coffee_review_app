class FixShops < ActiveRecord::Migration[7.0]
  def change
    remove_index :shops, column: :name
    add_index :shops, :place_id, unique: true
  end
end

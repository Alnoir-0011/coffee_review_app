class CreateBrewingPrefences < ActiveRecord::Migration[7.0]
  def change
    create_table :brewing_prefences do |t|
      t.references :user, null: false, foreign_key: true
      t.references :brewing_method, null: false, foreign_key: true

      t.timestamps
    end

    add_index :brewing_prefences, [:user_id, :brewing_method_id], unique: true
  end
end

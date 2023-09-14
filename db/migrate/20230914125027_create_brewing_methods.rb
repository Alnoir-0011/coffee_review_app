class CreateBrewingMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :brewing_methods do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end

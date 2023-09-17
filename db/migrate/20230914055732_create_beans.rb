class CreateBeans < ActiveRecord::Migration[7.0]
  def change
    create_table :beans do |t|
      t.string :name, null: false
      t.integer :roast, null: false, default: 0
      t.integer :fineness, null: false, default: 0
      t.references :region, null: false, foreign_key: true

      t.timestamps
    end
  end
end

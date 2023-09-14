class CreateDealers < ActiveRecord::Migration[7.0]
  def change
    create_table :dealers do |t|
      t.references :beans, null: false, foreign_key: true
      t.references :shops, null: false, foreign_key: true

      t.timestamps
    end
  end
end

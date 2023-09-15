class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :title, null: false
      t.integer :fineness, null: false, default: 0
      t.integer :evaluation, null: false
      t.text :content
      t.references :purchase, null: false, foreign_key: true
      t.references :brewing_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end

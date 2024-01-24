class CreateTopSliders < ActiveRecord::Migration[7.0]
  def change
    create_table :top_sliders do |t|
      t.string :name, null: false
      t.json :image, null: false
      t.datetime :end_of_publication

      t.timestamps
    end
  end
end

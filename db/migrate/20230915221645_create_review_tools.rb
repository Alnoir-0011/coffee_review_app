class CreateReviewTools < ActiveRecord::Migration[7.0]
  def change
    create_table :review_tools do |t|
      t.references :review, null: false, foreign_key: true
      t.references :tool, null: false, foreign_key: true

      t.timestamps
    end

    add_index :review_tools, [:review_id, :tool_id], unique: true
  end
end

class AddBeansToImage < ActiveRecord::Migration[7.0]
  def change
    add_column :beans, :image, :json
  end
end

class AddaAvatarToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar, :json
  end
end

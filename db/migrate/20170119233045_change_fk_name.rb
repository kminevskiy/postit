class ChangeFkName < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts, :users_id, :user_id
  end
end
